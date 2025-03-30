import 'package:flutter/material.dart';

class CustomDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    String? primaryButtonText = "OK",
    VoidCallback? onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    Color primaryButtonColor = const Color.fromARGB(255, 255, 94, 94),
    Color secondaryButtonColor = const Color(0xFF292929),
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (secondaryButtonText != null) ...[
                  _buildDialogButton(
                    context,
                    text: secondaryButtonText,
                    onPressed: onSecondaryPressed,
                    color: secondaryButtonColor,
                  ),
                  const SizedBox(width: 10),
                ],
                _buildDialogButton(
                  context,
                  text: primaryButtonText!,
                  onPressed: onPrimaryPressed,
                  color: primaryButtonColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDialogButton(
    BuildContext context, {
    required String text,
    VoidCallback? onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
        if (onPressed != null) {
          onPressed();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
