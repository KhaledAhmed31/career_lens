import 'dart:ui';

import 'package:career_lens/core/utils/const/app_images.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;

  const CustomScaffold({super.key, required this.body, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          // 1️⃣ الخلفية (صورة أو لون)
          Positioned.fill(
            child: Image.asset(AppImages.bgImage, fit: BoxFit.cover),
          ),

          // 2️⃣ طبقة الـ Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 1),
              child: Container(color: Colors.black.withAlpha(20)),
            ),
          ),

          // 3️⃣ المحتوى فوق الـ blur
          body,
        ],
      ),
    );
  }
}
