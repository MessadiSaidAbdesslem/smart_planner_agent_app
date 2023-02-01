import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({Key? key, this.isElevated = false, required this.child})
      : super(key: key);

  bool isElevated;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isElevated ? 20 : 10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: isElevated ? 4 : 10,
                offset: isElevated ? const Offset(0, 4) : Offset.zero,
                color: Colors.black.withOpacity(0.05))
          ]),
      child: child,
    );
  }
}
