import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/role_controller.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';

class PersonaliseRolePage extends StatelessWidget {
  PersonaliseRolePage({Key? key}) : super(key: key);
  static const id = "/PersonaliseRolePage";
  final RoleController roleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RRAppBar("Customiser le rôle"),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(width: double.infinity, height: 24),
        SizedBox(
          width: min(80.w, 600),
          child: const Text(
            "Rôle au sein de l'entreprise:",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: min(80.w, 600),
          child: CustomTextFormField(
            placeholder: "Rôle customisé",
            controller: roleController.customRoleTextEditingController,
          ),
        ),
        const Spacer(),
        PrimaryButton(
            onPressed: () async {
              roleController.role.value =
                  roleController.customRoleTextEditingController.text.trim();

              if (roleController.role.value != "") {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(Get.arguments['id'])
                    .update({"role": roleController.role.value});

                Get.back();
                Get.back();
              }
            },
            child: const Text("Enregistrer")),
        const SizedBox(height: 30),
      ]),
    );
  }
}
