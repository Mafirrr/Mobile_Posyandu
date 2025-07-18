import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; // Allow async
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double borderRadius;
  final double height;
  final double? width;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = const Color.fromARGB(255, 29, 97, 231),
    this.textColor = Colors.white,
    this.fontSize = 18.0,
    this.borderRadius = 10.0,
    this.height = 50.0,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.5,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, 
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(color: textColor, fontSize: fontSize),
              ),
      ),
    );
  }
}
