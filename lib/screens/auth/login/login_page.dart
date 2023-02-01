import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/screens/auth/reset/reset_password.dart';
import 'package:smart_planner_agent_app/screens/auth/signup/signup_page.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);
  static const id = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(),
            const SizedBox(height: 50),
            SizedBox(
                height: 140,
                width: 140,
                child: Image.asset("assets/logoalone2.png")),
            const Text("SmartBoard",
                style: TextStyle(
                    fontSize: 32,
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 35),
            SizedBox(
              width: min(80.w, 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Connexion",
                    style: TextStyle(
                        color: Constants.primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Form(
                key: controller.loginFormKey,
                child: Column(children: [
                  CustomTextFormField(
                      prefix: const Icon(Icons.email,
                          color: Constants.primaryColor),
                      placeholder: "Votre email",
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
                  CustomTextFormField(
                      prefix:
                          const Icon(Icons.lock, color: Constants.primaryColor),
                      placeholder: "Mot de passe",
                      isPassword: true,
                      controller: controller.passwordController,
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return "champ obligatoire";
                        }
                      }),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(ResetPasswordPage.id);
                    },
                    child: const Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                          color: Constants.primaryColor,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => PrimaryButton(
                        onPressed: () {
                          if (controller.loginFormKey.currentState!
                              .validate()) {
                            controller.authenticateWithEmailPassword();
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
                            : const Text("Connecter")),
                  )
                ]),
              ),
            ),
            const SizedBox(height: 22),
            PrimaryButton(
                isSecondary: true,
                onPressed: () {
                  Get.toNamed(SignupPage.id);
                },
                child: const Text("Nouveau compte")),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
