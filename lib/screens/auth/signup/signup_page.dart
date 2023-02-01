import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';

class SignupPage extends GetView<AuthController> {
  const SignupPage({Key? key}) : super(key: key);
  static const id = "/signup";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Constants.primaryColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Get.back();
            }),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 0),
            SizedBox(
                height: 140,
                width: 140,
                child: Image.asset("assets/logoalone2.png")),
            const Text("SmartBoard",
                style: TextStyle(
                    fontSize: 32,
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 35, width: double.infinity),
            SizedBox(
              width: min(80.w, 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Inscription",
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
                key: controller.signupFormKey,
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
                      prefix: const Icon(Icons.create_outlined,
                          color: Constants.primaryColor),
                      placeholder: "Nom",
                      controller: controller.nomController,
                      validator: (value) {
                        RegExp emailRegex =
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                        if ((value == null || value.trim().isEmpty)) {
                          return "champ obligatoire";
                        }
                      }),
                  const SizedBox(height: 22),
                  CustomTextFormField(
                      prefix: const Icon(Icons.create_outlined,
                          color: Constants.primaryColor),
                      placeholder: "Prenom",
                      controller: controller.prenomController,
                      validator: (value) {
                        RegExp emailRegex =
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                        if ((value == null || value.trim().isEmpty)) {
                          return "champ obligatoire";
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
                  const SizedBox(height: 52),
                  Obx(
                    () => PrimaryButton(
                        onPressed: () async {
                          if (controller.signupFormKey.currentState!
                              .validate()) {
                            await controller.singUpAgent();
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
                            : const Text("Inscription")),
                  )
                ]),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      )),
    );
  }
}
