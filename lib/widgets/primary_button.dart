import 'dart:math';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.showBorder = true,
      this.isSecondary = false})
      : super(key: key);
  Widget child;
  void Function()? onPressed;
  bool isSecondary;
  bool showBorder;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSecondary ? Colors.white : Constants.primaryColor,
              border: showBorder
                  ? Border.all(color: Constants.primaryColor)
                  : null),
          width: min(80.w, 600),
          height: 52,
          child: Center(
              child: Material(
            color: Colors.transparent,
            textStyle: TextStyle(
                color: isSecondary ? Constants.primaryColor : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600),
            child: child,
          ))),
    );
  }
}
