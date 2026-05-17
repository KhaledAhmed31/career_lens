import 'package:career_lens/core/ui/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    this.onChange,
    required this.controller,
    required this.focusNode,
  });
  final String hint;
  final void Function(String)? onChange;
  final TextEditingController controller;
  final FocusNode focusNode;
  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChange,
      focusNode: widget.focusNode,
      onTapOutside: (event) => widget.focusNode.unfocus(),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
        ),
        hintText: widget.hint,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: AppColors.grayHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 15,
        ),
      ),
      cursorColor: AppColors.primaryColor,
      style: TextStyle(
        color: AppColors.primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
