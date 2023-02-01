import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/role_controller.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/personaliseRolePage/personalise_role_page.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';
import 'package:smart_planner_agent_app/widgets/selectable_card.dart';
import 'package:sizer/sizer.dart';

class RolePage extends StatelessWidget {
  RolePage({Key? key}) : super(key: key);

  static const id = "/RolePage";

  final RoleController roleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RRAppBar("Modifiler le rôle"),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(width: double.infinity, height: 24),
                SizedBox(
                  width: min(80.w, 600),
                  child: const Text(
                    "Rôle au sein de l'entreprise:",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Obx(
                  () => SelectableCard<String>(
                    value: "lit",
                    groupValue: roleController.role.value,
                    onChanged: (value) {
                      if (value != null) roleController.role.value = value;
                    },
                    title: const Text("Lit"),
                  ),
                ),
                Obx(
                  () => SelectableCard<String>(
                    value: "cuisine",
                    groupValue: roleController.role.value,
                    onChanged: (value) {
                      if (value != null) roleController.role.value = value;
                    },
                    title: const Text("Cuisine"),
                  ),
                ),
                Obx(
                  () => SelectableCard<String>(
                    value: "salle de bain",
                    groupValue: roleController.role.value,
                    onChanged: (value) {
                      if (value != null) roleController.role.value = value;
                    },
                    title: const Text("salle de bain"),
                  ),
                ),
                Obx(
                  () => SelectableCard<String>(
                    value: "aspirateur",
                    groupValue: roleController.role.value,
                    onChanged: (value) {
                      if (value != null) roleController.role.value = value;
                    },
                    title: const Text("aspirateur"),
                  ),
                ),
                Obx(
                  () => SelectableCard<String>(
                    value: "contrôle",
                    groupValue: roleController.role.value,
                    onChanged: (value) {
                      if (value != null) roleController.role.value = value;
                    },
                    title: const Text("contrôle"),
                  ),
                ),
              ],
            ),
          ),
        ),
        PrimaryButton(
            onPressed: () async {
              if (roleController.role.value != "") {
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(Get.arguments['id'])
                    .update({'role': roleController.role.value});
              } else {}
              Get.back();
            },
            child: const Text("Enregistrer")),
        const SizedBox(height: 14),
        PrimaryButton(
            isSecondary: true,
            onPressed: () {
              Get.toNamed(PersonaliseRolePage.id,
                  arguments: {"id": Get.arguments['id']});
            },
            child: const Text("Personaliser")),
        const SizedBox(height: 14)
      ]),
    );
  }
}
