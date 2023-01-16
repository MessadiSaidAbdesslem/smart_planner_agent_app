import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
        child: Row(children: [Icon(icon), SizedBox(width: 2.w), Text(text)]),
      ),
    );
  }
}
