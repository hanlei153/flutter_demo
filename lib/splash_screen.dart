import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'Local_Storage/shared_preferences.dart';
import 'pages/login/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  List<bool> _isVisible = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _animateText();

    // 延迟 3 秒后跳转到主页
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
        ),
      );
    });
  }

  // 逐字动画
  void _animateText() {
    for (int i = 0; i < _isVisible.length; i++) {
      Future.delayed(Duration(milliseconds: 500 * i), () {
        if (mounted) {
          setState(() {
            _isVisible[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 21, 21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/logo2.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _isVisible.length; i++)
                  AnimatedOpacity(
                    opacity: _isVisible[i] ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Text(
                      '欢迎回来'[i],
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 100, 99, 99),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
