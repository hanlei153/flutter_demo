import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60), // 圆角半径
                  child: Image.asset(
                    'assets/image.png',
                    width: 120, // 图片宽度
                    height: 120, // 图片高度
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 50), // 添加间距
                Text(
                  "HanLei's app",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 80),
                Text(
                  '客服电话：110',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 152, 153, 153)),
                ),
                Text(
                  'ICP备案号：110-110-110-110-110',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 152, 153, 153)),
                ),
              ],
            ),
          ),
        ));
  }
}
