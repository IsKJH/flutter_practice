import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Layout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  Layout({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(index,
        initialLocation: index == navigationShell.currentIndex);
  }

  final bottomNavIconList = <IconData>[
    Icons.home,
    Icons.search,
    Icons.bar_chart,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child: navigationShell),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.lightBlue,
          onPressed: () {
            // 플로팅 버튼 기능 추가 가능
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: bottomNavIconList.length,
            tabBuilder: (int index, bool isActive) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    bottomNavIconList[index],
                    color: isActive ? Colors.lightBlue : Colors.grey,
                  ),
                ],
              );
            },
            activeIndex: navigationShell.currentIndex,
            gapLocation: GapLocation.center,
            rightCornerRadius: 32,
            shadow: BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0.5,
            ),
            onTap: _goBranch));
  }
}
