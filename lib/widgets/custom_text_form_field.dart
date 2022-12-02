import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    Key? key,
    this.validator,
    this.isPassword = false,
    required this.placeholder,
    required this.controller,
    this.keyboard = TextInputType.text,
  }) : super(key: key);

  String? Function(String?)? validator;
  final TextEditingController controller;
  bool isPassword;
  String placeholder;
  TextInputType keyboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        keyboardType: keyboard,
        decoration: InputDecoration(
            hintText: placeholder,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        obscureText: isPassword,
        controller: controller,
        validator: validator,
      ),
    );
  }
}
