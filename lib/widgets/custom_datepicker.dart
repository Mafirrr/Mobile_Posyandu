import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends FormField<DateTime> {
  CustomDatePicker({
    Key? key,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    required ValueChanged<DateTime> onDateSelected,
    FormFieldValidator<DateTime>? validator,
    String hintText = "Pilih Tanggal",
    IconData icon = Icons.calendar_today,
  }) : super(
          key: key,
          initialValue: initialDate,
          validator: validator,
          builder: (FormFieldState<DateTime> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: state.context,
                      initialDate: state.value ?? DateTime.now(),
                      firstDate: firstDate ?? DateTime(2000),
                      lastDate: lastDate ?? DateTime(2100),
                    );
                    if (pickedDate != null) {
                      state.didChange(pickedDate);
                      onDateSelected(pickedDate);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: state.hasError ? Colors.red : Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.value != null
                              ? DateFormat('dd MMM yyyy').format(state.value!)
                              : hintText, // Customizable placeholder
                          style: TextStyle(
                            fontSize: 16,
                            color: state.value != null
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        Icon(icon, color: Colors.black), // Customizable icon
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}
