import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    this.onPressed,
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  void Function()? onPressed;
  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 52,
        width: min(600, 80.w),
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ]),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(children: [
          Icon(
            icon,
            size: 20,
            color: Constants.primaryColor,
          ),
          const SizedBox(width: 25),
          Text(
            text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.7)),
          ),
          const Spacer(),
          RotatedBox(
            quarterTurns: 2,
            child: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Colors.black.withOpacity(0.3),
            ),
          )
        ]),
      ),
    );
  }
}
