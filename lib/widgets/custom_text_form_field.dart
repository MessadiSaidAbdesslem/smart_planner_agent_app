import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:sizer/sizer.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
      this.validator,
      this.isPassword = false,
      required this.placeholder,
      required this.controller,
      this.keyboard = TextInputType.text,
      this.prefix,
      this.inputFormatters,
      this.enableLabel = false,
      this.onTap})
      : super(key: key);

  void Function()? onTap;
  String? Function(String?)? validator;
  final TextEditingController controller;
  bool isPassword;
  String placeholder;
  TextInputType keyboard;
  Widget? prefix;
  List<TextInputFormatter>? inputFormatters;
  bool enableLabel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: min(80.w, 600),
      child: TextFormField(
        onTap: onTap,
        inputFormatters: inputFormatters,
        keyboardType: keyboard,
        style: const TextStyle(color: Constants.primaryColor),
        decoration: InputDecoration(
            label: enableLabel
                ? Text(
                    placeholder,
                    style: const TextStyle(color: Constants.primaryColor),
                  )
                : null,
            hintStyle:
                TextStyle(color: Constants.primaryColor.withOpacity(0.5)),
            filled: true,
            fillColor: Constants.accentColor,
            prefixIcon: prefix,
            hintText: placeholder,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent))),
        obscureText: isPassword,
        controller: controller,
        validator: validator,
      ),
    );
  }
}
