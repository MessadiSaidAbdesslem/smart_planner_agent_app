import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:sizer/sizer.dart';

class ResetPasswordPage extends GetView<AuthController> {
  const ResetPasswordPage({Key? key}) : super(key: key);

  static const id = "/resetPassword";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Réinitialiser mot de passe",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new), onPressed: Get.back),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/forgot_password.png"),
              const SizedBox(height: 22),
              Form(
                key: controller.resetPasswordFormKey,
                child: Column(children: [
                  const SizedBox(width: double.infinity),
                  SizedBox(
                    width: min(80.w, 600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text("Veuillez entrer votre email:",
                            style: TextStyle(fontSize: 18))
                      ],
                    ),
                  ),
                  const SizedBox(height: 11),
                  CustomTextFormField(
                      prefix: const Icon(Icons.email,
                          color: Constants.primaryColor),
                      placeholder: "email",
                      controller: controller.emailController,
                      validator: (value) {
                        RegExp emailRegex =
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                        if ((value == null || value.isEmpty)) {
                          return "champ obligatoire";
                        } else if (emailRegex.firstMatch(value) == null) {
                          return "Example: mail@domain.com";
                        }
                      }),
                  const SizedBox(height: 22),
                  Obx(
                    () => PrimaryButton(
                        onPressed: () async {
                          if (controller.resetPasswordFormKey.currentState!
                              .validate()) {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: controller.emailController.text);

                            Get.showSnackbar(const GetSnackBar(
                              messageText: Text(
                                "E-mail envoyé!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ));

                            Future.delayed(const Duration(seconds: 3))
                                .then((value) => Get.closeAllSnackbars());
                          }
                        },
                        child: controller.loading.value
                            ? const SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Envoyer")),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
