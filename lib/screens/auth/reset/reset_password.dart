import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';

class ResetPasswordPage extends GetView<AuthController> {
  const ResetPasswordPage({Key? key}) : super(key: key);

  static const id = "/resetPassword";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.green,
        elevation: 0,
        title: const Text("Réinitialiser mot de passe"),
      ),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(5.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Form(
              key: controller.resetPasswordFormKey,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text("Veuillez entrer votre email:"),
                    ],
                  ),
                ),
                CustomTextFormField(
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
                SizedBox(height: 1.w),
                Obx(
                  () => SizedBox(
                    width: 50.w,
                    child: ElevatedButton(
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
                  ),
                )
              ]),
            ),
          ),
        ],
      )),
    );
  }
}
