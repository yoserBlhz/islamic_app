import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class CustomBottomNavBar extends StatelessWidget {
  final MotionTabBarController? motionTabBarController;
  final Function(int) onTabItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.motionTabBarController,
    required this.onTabItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return MotionTabBar(
      controller: motionTabBarController,
      initialSelectedTab: "Home",
      labels: const ["Tasbih", "Videos", "Home", "Adhkar"],
      icons: const [
        Icons.spa,
        Icons.video_library,
        Icons.home,
        Icons.book,
      ],
      tabSize: 50,
      tabBarHeight: 55,
      tabIconSize: 28.0,
      tabIconSelectedSize: 26.0,
      tabSelectedColor: Colors.blue[900],
      tabIconSelectedColor: Colors.white,
      tabBarColor: Colors.blue[800],
      textStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      onTabItemSelected: onTabItemSelected,
    );
  }
}
