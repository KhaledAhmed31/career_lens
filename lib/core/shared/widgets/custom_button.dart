import 'package:career_lens/core/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.padding,
  });
  final void Function()? onPressed;
  final String text;
  final double padding;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
        padding: EdgeInsets.symmetric(horizontal: padding, vertical: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      child: Text(text),
    );
  }
}
