import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';

class SelectableCard<T> extends StatelessWidget {
  SelectableCard(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.title})
      : super(key: key);
  T value;
  T? groupValue;
  void Function(T?) onChanged;
  Widget title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        height: 52,
        width: min(80.w, 600),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: value == groupValue
              ? Constants.primaryColor.withOpacity(0.7)
              : Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
          ],
        ),
        child: Material(
            color: Colors.transparent,
            textStyle: TextStyle(
                color: groupValue == value ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold),
            child: title),
      ),
    );
  }
}
