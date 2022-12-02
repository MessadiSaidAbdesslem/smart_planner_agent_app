import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_planner_agent_app/controllers/edit_personnal_info.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/widgets/custom_text_form_field.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:sizer/sizer.dart';

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
      appBar: AppBar(title: const Text("Modifier vos informations")),
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
                              width: 150,
                              height: 150,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 2.w),
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
                        Form(
                          key: controller.editFormKey,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Column(children: [
                              CustomTextFormField(
                                  controller: controller
                                      .displayNamedTextEditingController,
                                  placeholder: "Nom et Prénom",
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Champ obligatoire";
                                    }
                                  }),
                              CustomTextFormField(
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
                        Obx(
                          () => ElevatedButton(
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
                        )
                      ]),
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          })),
    );
  }
}
