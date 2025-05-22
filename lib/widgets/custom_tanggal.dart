import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTanggal extends StatefulWidget {
  final TextEditingController controller;
  final DateTime? value;
  final String hintText;
  final IconData icon;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? Function(String?)? validator;
  final double fontSize;
  final double height;
  final EdgeInsetsGeometry contentPadding;

  const CustomTanggal({
    Key? key,
    required this.controller,
    required this.onDateSelected,
    this.value,
    this.hintText = "Pilih Tanggal",
    this.icon = Icons.calendar_today,
    this.firstDate,
    this.lastDate,
    this.validator,
    this.fontSize = 14,
    this.height = 44,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12),
  }) : super(key: key);

  @override
  State<CustomTanggal> createState() => _CustomTanggalState();
}

class _CustomTanggalState extends State<CustomTanggal> {
  DateTime? selectedDate;

  @override
  void didUpdateWidget(covariant CustomTanggal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && selectedDate != null) {
      setState(() {
        selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isError = widget.validator?.call(widget.controller.text) != null;

    return GestureDetector(
      onTap: () async {
        DateTime initial = selectedDate ?? widget.value ?? DateTime.now();

        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: widget.firstDate ?? DateTime(2000),
          lastDate: widget.lastDate ?? DateTime(2100),
        );

        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
          widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
          widget.onDateSelected(picked);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: widget.height,
            padding: widget.contentPadding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isError ? Colors.red : Colors.grey.shade400,
                width: 1,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.controller.text.isNotEmpty
                        ? widget.controller.text
                        : widget.hintText,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      color: widget.controller.text.isNotEmpty
                          ? Colors.black
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
                Icon(widget.icon, size: 18, color: Colors.black54),
              ],
            ),
          ),
          if (isError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                widget.validator!(widget.controller.text)!,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: widget.fontSize - 2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
