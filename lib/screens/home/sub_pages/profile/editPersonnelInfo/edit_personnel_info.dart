import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_planner_agent_app/controllers/edit_personnal_info.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';

class EditPersonnelInfoPage extends GetView<EditPersonnalInfoController> {
  EditPersonnelInfoPage({Key? key}) : super(key: key);
  final userSNapshots = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  static const id = "/EditPersonnelInfoPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RRAppBar("Modifier vos information"),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userSNapshots,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return ErrorMessageWidget(error: snapshot.error.toString());
              }
              if (snapshot.hasData && snapshot.data != null) {
                Agent agent = Agent.fromMap(snapshot.data!.data()!);
                return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 14, width: double.infinity),
                        Obx(
                          () => GestureDetector(
                            onTap: () async {
                              XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (image == null) return;

                              controller.pictureIsSet.value = true;
                              controller.imagePath.value = image.path;
                              if (image.name.split(".")[1] == "jpg") {
                                controller.mimeType.value = "image/jpeg";
                              } else {
                                controller.mimeType.value =
                                    "image/${image.name.split(".")[1]}";
                              }
                            },
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(75),
                                  border: Border.all(color: Colors.black)),
                              child: !controller.pictureIsSet.value
                                  ? Image.network(agent.imageUrl,
                                      fit: BoxFit.fill)
                                  : Image.file(File(controller.imagePath.value),
                                      fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: min(80.w, 600),
                          child: Row(
                            children: [
                              Text("Informations Personnel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black.withOpacity(0.7))),
                            ],
                          ),
                        ),
                        Form(
                          key: controller.editFormKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(children: [
                              CustomTextFormField(
                                  prefix: const Icon(Icons.create_outlined,
                                      color: Constants.primaryColor),
                                  controller: controller
                                      .displayNamedTextEditingController,
                                  placeholder: "Nom et Prénom",
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Champ obligatoire";
                                    }
                                  }),
                              const SizedBox(height: 14),
                              CustomTextFormField(
                                prefix: const Icon(
                                  Icons.phone,
                                  color: Constants.primaryColor,
                                ),
                                controller:
                                    controller.numeroTextEditingController,
                                placeholder: "Numero de téléphone",
                                keyboard: TextInputType.phone,
                                validator: (value) {
                                  if (value != null &&
                                      !value.isPhoneNumber &&
                                      value.isNotEmpty) {
                                    return "example: +1 XXX-XXXX-XXXX";
                                  }
                                },
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Obx(
                          () => PrimaryButton(
                              onPressed: () async {
                                if (controller.editFormKey.currentState!
                                    .validate()) {
                                  await controller.updateProfileData();
                                }
                              },
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Enregistrer")),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: min(80.w, 600),
                          child: Row(
                            children: [
                              Text("Changer mot de passe",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.black.withOpacity(0.7))),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Form(
                          key: controller.passwordFormKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(children: [
                              CustomTextFormField(
                                  prefix: const Icon(Icons.lock,
                                      color: Constants.primaryColor),
                                  isPassword: true,
                                  controller: controller.oldPassword,
                                  placeholder: "Ancien mot de passe",
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Champ obligatoire";
                                    }
                                  }),
                              const SizedBox(height: 14),
                              CustomTextFormField(
                                  prefix: const Icon(Icons.lock,
                                      color: Constants.primaryColor),
                                  isPassword: true,
                                  controller: controller.newPassword,
                                  placeholder: "Nouveau mot de passe",
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Champ obligatoire";
                                    }
                                  }),
                              const SizedBox(height: 14),
                              CustomTextFormField(
                                prefix: const Icon(Icons.lock,
                                    color: Constants.primaryColor),
                                isPassword: true,
                                controller: controller.confirmPassword,
                                placeholder: "Confirmer mot de passe",
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Champ obligatoire";
                                  }
                                  if (value != controller.newPassword.text) {
                                    return "le mot de passe ne correspond pas";
                                  }
                                },
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Obx(
                          () => PrimaryButton(
                              onPressed: () async {
                                if (controller.passwordFormKey.currentState!
                                    .validate()) {
                                  await controller.updatePassword();
                                }
                              },
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Enregistrer")),
                        ),
                        const SizedBox(height: 30)
                      ]),
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          })),
    );
  }
}
