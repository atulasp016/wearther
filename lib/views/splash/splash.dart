
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/utils/app_images.dart';
import 'package:weather/views/home/home.dart';

class SplashPage extends StatefulWidget {


  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Image.asset(AppImages.IC_LOGO,
             fit: BoxFit.fill)));
  }
}
