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
  }) : super(key: key);

  @override
  State<CustomTanggal> createState() => _CustomTanggalState();
}

class _CustomTanggalState extends State<CustomTanggal> {
  DateTime? selectedDate;

  @override
  void didUpdateWidget(covariant CustomTanggal oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Jika value dari luar menjadi null, reset juga internal state
    if (widget.value == null && selectedDate != null) {
      setState(() {
        selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.controller.text.isNotEmpty
                      ? widget.controller.text
                      : widget.hintText,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.controller.text.isNotEmpty
                        ? Colors.black
                        : Colors.grey,
                  ),
                ),
                Icon(widget.icon, color: Colors.black),
              ],
            ),
          ),
          if (widget.validator != null &&
              widget.validator!(widget.controller.text) != null)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                widget.validator!(widget.controller.text)!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
