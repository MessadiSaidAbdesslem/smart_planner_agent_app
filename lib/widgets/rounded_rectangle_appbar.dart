import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

AppBar RRAppBar(String title,
    {Widget? secondRow,
    Widget? backgroundImage,
    List<Widget>? actions,
    bool isHome = false}) {
  return AppBar(
    actions: actions,
    flexibleSpace: backgroundImage,
    backgroundColor: Constants.primaryColor,
    elevation: 0,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        secondRow ?? Container()
      ],
    ),
    leading: isHome
        ? null
        : IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            }),
    toolbarHeight: backgroundImage != null ? 125 : 75,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
  );
}
