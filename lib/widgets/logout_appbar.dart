import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/auth/login/login_page.dart';

PreferredSizeWidget LogoutAppBar(String title) {
  return AppBar(title: Text(title), actions: [
    IconButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Get.offAllNamed(LoginPage.id);
        },
        icon: const Icon(Icons.logout))
  ]);
}
