import 'package:flutter/foundation.dart';
import 'package:flutter_practice/constants/app_enums.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userTokenKey = 'userToken';
  static const String _userIdKey = 'userId';
  static const String _userNicknameKey = 'userNickname';
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  // 현재 로그인 상태 확인
  Future<bool> isLoggedIn() async {
    try {
      // 토큰이 유효한지 확인
      if (await AuthApi.instance.hasToken()) {
        try {
          // 토큰 유효성 검사
          AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
          if (kDebugMode) {
            print('토큰 유효, 만료시간: ${tokenInfo.expiresIn}초');
          }
          return true;
        } catch (error) {
          if (error is KakaoException && error.isInvalidTokenError()) {
            if (kDebugMode) {
              print('토큰 만료됨, 로그인 필요');
            }
            return false;
          }
          return false;
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('로그인 상태 확인 오류: $e');
      }
      return false;
    }
  }

  // 카카오 로그인
  Future<bool> loginWithKakao() async {
    try {
      OAuthToken token;
      
      // 카카오톡 앱이 설치되어 있는지 확인
      if (await isKakaoTalkInstalled()) {
        try {
          // 카카오톡으로 로그인
          token = await UserApi.instance.loginWithKakaoTalk();
          if (kDebugMode) {
            print('카카오톡으로 로그인 성공');
          }
        } catch (error) {
          if (kDebugMode) {
            print('카카오톡으로 로그인 실패 $error');
          }
          // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인 시도
          token = await UserApi.instance.loginWithKakaoAccount();
          if (kDebugMode) {
            print('카카오계정으로 로그인 성공');
          }
        }
      } else {
        // 카카오계정으로 로그인
        token = await UserApi.instance.loginWithKakaoAccount();
        if (kDebugMode) {
          print('카카오계정으로 로그인 성공');
        }
      }

      // 로그인 성공 후 사용자 정보 가져오기
      await _getUserInfo();
      
      // SharedPreferences에 로그인 상태 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_userTokenKey, token.accessToken);

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('카카오 로그인 실패 $error');
      }
      return false;
    }
  }

  // 사용자 정보 가져오기
  Future<void> _getUserInfo() async {
    try {
      User user = await UserApi.instance.me();
      
      if (kDebugMode) {
        print('━━━━━━ 카카오 계정 정보 ━━━━━━');
        print('회원번호: ${user.id}');
        print('이메일: ${user.kakaoAccount?.email ?? "이메일 없음"}');
        print('닉네임: ${user.kakaoAccount?.profile?.nickname ?? "닉네임 없음"}');
        print('프로필사진: ${user.kakaoAccount?.profile?.profileImageUrl ?? "프로필사진 없음"}');
        print('연령대: ${user.kakaoAccount?.ageRange ?? "연령대 정보 없음"}');
        print('성별: ${user.kakaoAccount?.gender ?? "성별 정보 없음"}');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━');
      }

      // SharedPreferences에 사용자 정보 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, user.id.toString());
      await prefs.setString(_userNicknameKey, 
          user.kakaoAccount?.profile?.nickname ?? "사용자");
      
    } catch (error) {
      if (kDebugMode) {
        print('사용자 정보 요청 실패 $error');
      }
    }
  }

  // 로그아웃
  Future<bool> logout() async {
    try {
      await UserApi.instance.logout();
      
      // SharedPreferences에서 사용자 정보 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_userTokenKey);
      await prefs.remove(_userIdKey);
      await prefs.remove(_userNicknameKey);

      if (kDebugMode) {
        print('로그아웃 성공');
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print('로그아웃 실패 $error');
      }
      return false;
    }
  }

  // 연결 끊기 (회원탈퇴)
  Future<bool> unlink() async {
    try {
      await UserApi.instance.unlink();
      
      // SharedPreferences에서 사용자 정보 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (kDebugMode) {
        print('연결 끊기 성공');
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        print('연결 끊기 실패 $error');
      }
      return false;
    }
  }

  // 저장된 사용자 토큰 가져오기
  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTokenKey);
  }

  // 저장된 사용자 ID 가져오기
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // 저장된 사용자 닉네임 가져오기
  Future<String?> getUserNickname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNicknameKey);
  }

  // 현재 사용자 정보 다시 가져오기
  Future<void> refreshUserInfo() async {
    if (await isLoggedIn()) {
      await _getUserInfo();
    }
  }

  // Legacy method for backwards compatibility
  @Deprecated('Use loginWithKakao() instead')
  Future<void> login(LoginType type) async {
    if (type == LoginType.kakao) {
      await loginWithKakao();
    }
  }
}
