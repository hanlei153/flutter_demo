import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('隐私协议'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text(
              'Remember. you have zero privacy on the Internet!',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ));
  }
}
