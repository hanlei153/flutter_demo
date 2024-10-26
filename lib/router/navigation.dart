// lib/navigation.dart

import 'package:flutter/material.dart';

enum SlideDirection { left, right }

void navigateToPages(
  BuildContext context,
  Widget Function() pageBuilder,
  SlideDirection direction,
) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => pageBuilder(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        if (direction == SlideDirection.left) {
          begin = Offset(-1.0, 0.0); // 从左边边进入
        } else {
          begin = Offset(1.0, 0.0); // 从右边进入
        }

        const end = Offset.zero; // 到达目标位置
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}
