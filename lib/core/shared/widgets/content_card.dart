import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({super.key, required this.content, this.height = 650});
  final List<Widget> content;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 28.0),
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(215),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: content,
      ),
    );
  }
}
