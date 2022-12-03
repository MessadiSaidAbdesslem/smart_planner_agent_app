import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoleController extends GetxController {
  RxString role = "".obs;
  RxBool isCustomRole = false.obs;
  TextEditingController customRoleTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    customRoleTextEditingController.dispose();
    super.dispose();
  }
}
