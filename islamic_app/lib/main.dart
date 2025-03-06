import 'package:flutter/material.dart';
import 'package:islamic_app/screens/adhkar_screen.dart';
import 'package:islamic_app/screens/home_screen.dart';
import 'package:islamic_app/screens/tasbih_screen.dart';
import 'package:islamic_app/screens/videos_screen.dart';
import 'package:islamic_app/widgets/custom_bottom_nav_bar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 2,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _motionTabBarController,
        children: <Widget>[
          TasbihPage(),
          VideoPage(),
          HomePage(),
          AdhkarPage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        motionTabBarController: _motionTabBarController,
        onTabItemSelected: (int index) {
          setState(() {
            _motionTabBarController!.index = index;
          });
        },
      ),
    );
  }
}
