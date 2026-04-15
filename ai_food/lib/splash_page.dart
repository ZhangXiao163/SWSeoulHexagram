import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  double opacity = 0; // ✅A 放这里

  @override
  void initState() {
    super.initState();

    // 淡入动画
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        opacity = 1;
      });
    });

    // 跳转首页
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(   // ✅ 用动画组件
          duration: Duration(seconds: 1),
          opacity: opacity,
          child: Image.asset(
            'assets/images/splash.png',
            width: 200,
          ),
        ),
      ),
    );
  }
}