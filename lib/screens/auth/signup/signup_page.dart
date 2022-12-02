import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';

import 'package:sizer/sizer.dart';

class SignupPage extends GetView<AuthController> {
  const SignupPage({Key? key}) : super(key: key);
  static const id = "/signup";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.green,
        title: const Text("Nouveau compte"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.all(5.w),
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Form(
                key: controller.signupFormKey,
                child: Column(children: [
                  CustomTextFormField(
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
                  CustomTextFormField(
                      placeholder: "Nom",
                      controller: controller.nomController,
                      validator: (value) {
                        RegExp emailRegex =
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                        if ((value == null || value.trim().isEmpty)) {
                          return "champ obligatoire";
                        }
                      }),
                  CustomTextFormField(
                      placeholder: "Prenom",
                      controller: controller.prenomController,
                      validator: (value) {
                        RegExp emailRegex =
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                        if ((value == null || value.trim().isEmpty)) {
                          return "champ obligatoire";
                        }
                      }),
                  CustomTextFormField(
                      placeholder: "Mot de passe",
                      isPassword: true,
                      controller: controller.passwordController,
                      validator: (value) {
                        if ((value == null || value.isEmpty)) {
                          return "champ obligatoire";
                        }
                      }),
                  SizedBox(height: 1.w),
                  Obx(
                    () => SizedBox(
                      width: 50.w,
                      child: ElevatedButton(
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
                    ),
                  )
                ]),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
