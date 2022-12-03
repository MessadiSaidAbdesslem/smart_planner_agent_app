import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/role_controller.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/personaliseRolePage/personalise_role_page.dart';

class RolePage extends StatelessWidget {
  RolePage({Key? key}) : super(key: key);

  static const id = "/RolePage";

  final RoleController roleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifiler le rôle")),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Tâche au sein de l'entreprise :"),
        ),
        Obx(
          () => RadioListTile<String>(
            value: "lit",
            groupValue: roleController.role.value,
            onChanged: (value) {
              if (value != null) roleController.role.value = value;
            },
            title: const Text("Lit"),
          ),
        ),
        Obx(
          () => RadioListTile<String>(
            value: "cuisine",
            groupValue: roleController.role.value,
            onChanged: (value) {
              if (value != null) roleController.role.value = value;
            },
            title: const Text("Cuisine"),
          ),
        ),
        Obx(
          () => RadioListTile<String>(
            value: "salle de bain",
            groupValue: roleController.role.value,
            onChanged: (value) {
              if (value != null) roleController.role.value = value;
            },
            title: const Text("salle de bain"),
          ),
        ),
        Obx(
          () => RadioListTile<String>(
            value: "aspirateur",
            groupValue: roleController.role.value,
            onChanged: (value) {
              if (value != null) roleController.role.value = value;
            },
            title: const Text("aspirateur"),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
                onPressed: () {
                  Get.toNamed(PersonaliseRolePage.id);
                },
                child: const Text("Personaliser")),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({'role': roleController.role.value});
                  Get.back();
                },
                child: const Text("Enregistrer")),
          ],
        )
      ]),
    );
  }
}
