import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/navigator_controller.dart';

import '../screens/auth/login/login_page.dart';

PreferredSizeWidget LogoutAppBar() {
  NavigatorController navigatorController = Get.find();
  return AppBar(
      title: Obx(() => Text(navigatorController.index.value == 0
          ? "Commande"
          : navigatorController.index.value == 1
              ? "Messagerie"
              : "Profile")),
      actions: [
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(LoginPage.id);
            },
            icon: const Icon(Icons.logout))
      ]);
}
