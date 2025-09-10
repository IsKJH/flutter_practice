import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_practice/services/auth_service.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'config/router.dart';

void main() async {
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  KakaoSdk.init(
    nativeAppKey: '3c9d7176a6f834300074f4dbaf08342b',
    javaScriptAppKey: 'dc3cf4624e44967d23db265e0ad94b68',
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  _initializeSplash() async {
    final authService = AuthService();
    await authService.isLoggedIn();

    await Future.delayed(const Duration(milliseconds: 1500));

    FlutterNativeSplash.remove();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      routerConfig: AppRouter.router,
    );
  }
}
