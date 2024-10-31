import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'Local_Storage/shared_preferences.dart';
import 'pages/login/login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 使用 Future.delayed 在一段时间后导航到主页
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FutureBuilder<bool>(
            future: LocalStorageManager().getBool('isLoggedIn'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data == true) {
                return MyHomePage();
              } else {
                return LoginPage();
              }
            },
          ),
        ), // 你的主页
      );
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 21, 21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icon/logo.png'),
            Text(
              '欢迎回来',
              style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 245, 241, 241)),
            ),
          ],
        ),
      ),
    );
  }
}
