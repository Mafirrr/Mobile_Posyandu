import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final EdgeInsetsGeometry padding;
  final int? maxLines;
  final String? Function(String?)? validator;
  final double borderRadius;
  final InputBorder? border;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final bool filled;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
    this.maxLines = 1,
    this.borderRadius = 8.0,
    this.border,
    this.textStyle,
    this.labelStyle,
    this.fillColor,
    this.filled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        style: textStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: labelStyle,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: filled,
          fillColor: fillColor,
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
