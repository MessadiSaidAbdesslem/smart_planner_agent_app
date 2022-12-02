import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/screens/auth/reset/reset_password.dart';
import 'package:smart_planner_agent_app/screens/auth/signup/signup_page.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  static const id = "/login_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Smart Board",
              style: TextStyle(fontSize: 36, color: Colors.green)),
          Container(
            margin: EdgeInsets.all(5.w),
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Form(
              key: controller.loginFormKey,
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
                    placeholder: "Mot de passe",
                    isPassword: true,
                    controller: controller.passwordController,
                    validator: (value) {
                      if ((value == null || value.isEmpty)) {
                        return "champ obligatoire";
                      }
                    }),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(ResetPasswordPage.id);
                  },
                  child: const Text(
                    "Mot de passe oublié?",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                SizedBox(
                  height: 1.w,
                ),
                Obx(
                  () => SizedBox(
                    width: 50.w,
                    child: ElevatedButton(
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
                  ),
                )
              ]),
            ),
          ),
          SizedBox(
              width: 50.w,
              child: OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    Get.toNamed(SignupPage.id);
                  },
                  child: const Text("Nouveau compte"))),
        ],
      )),
    );
  }
}
