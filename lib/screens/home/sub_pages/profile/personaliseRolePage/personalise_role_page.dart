import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/role_controller.dart';

class PersonaliseRolePage extends StatelessWidget {
  PersonaliseRolePage({Key? key}) : super(key: key);
  static const id = "/PersonaliseRolePage";
  final RoleController roleController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customiser le rôle"),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Tache au sein de l'entreprise :"),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: 90.w,
          child: TextField(
            decoration: InputDecoration(
                hintText: "Role customisé",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
            controller: roleController.customRoleTextEditingController,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  roleController.role.value = roleController
                      .customRoleTextEditingController.text
                      .trim();

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .update({"role": roleController.role.value});

                  Get.back();
                  Get.back();
                },
                child: const Text("Enregistrer")),
          ],
        )
      ]),
    );
  }
}
