import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry padding;
  final int? maxLines;
  final String? Function(String?)? validator;
  final double borderRadius;
  final InputBorder? border;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final Color? fillColor;
  final bool filled;
  final bool readOnly;
  final bool enabled;
  final double fontSize;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final String? helperText;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.initialValue,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.maxLines = 1,
    this.validator,
    this.borderRadius = 8.0,
    this.border,
    this.textStyle,
    this.labelStyle,
    this.errorStyle,
    this.fillColor,
    this.filled = false,
    this.readOnly = false,
    this.enabled = true,
    this.fontSize = 16,
    this.onChanged,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.helperText,
    this.contentPadding,
  }) : assert(controller == null || initialValue == null,
            'Cannot provide both controller and initialValue');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: obscureText ? 1 : maxLines,
        validator: validator,
        style: textStyle ?? TextStyle(fontSize: fontSize),
        readOnly: readOnly,
        enabled: enabled,
        onChanged: onChanged,
        focusNode: focusNode,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: labelStyle,
          helperText: helperText,
          errorStyle: errorStyle,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          filled: filled,
          fillColor: fillColor,
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}
