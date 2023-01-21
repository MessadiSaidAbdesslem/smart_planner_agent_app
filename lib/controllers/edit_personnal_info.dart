import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/models/agent.dart';

class EditPersonnalInfoController extends GetxController {
  TextEditingController displayNamedTextEditingController =
      TextEditingController();

  TextEditingController numeroTextEditingController = TextEditingController();

  RxString imagePath = ''.obs;
  RxString mimeType = ''.obs;
  RxBool pictureIsSet = false.obs;

  RxBool isLoading = false.obs;

  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    displayNamedTextEditingController.dispose();
    numeroTextEditingController.dispose();
    super.dispose();
  }

  Future<void> clearAll() async {
    displayNamedTextEditingController.clear();
    numeroTextEditingController.clear();
    pictureIsSet.value = false;
    imagePath.value = '';
    mimeType.value = '';
    var res = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Agent agent = Agent.fromMap(res.data()!);
    displayNamedTextEditingController.text = agent.displayName;
    numeroTextEditingController.text = agent.phoneNumber;
  }

  Future<void> updateProfileData() async {
    isLoading.value = true;
    var user = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    try {
      if (pictureIsSet.value) {
        final newMetadata = SettableMetadata(
          contentType: mimeType.value,
        );
        var root = FirebaseStorage.instance.ref();

        String path =
            "/users/${DateTime.now().toString()}${FirebaseAuth.instance.currentUser!.uid}.${mimeType.value.split('/')[1]}";

        var res =
            await root.child(path).putFile(File(imagePath.value), newMetadata);

        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"imageUrl": await res.ref.getDownloadURL()});

        // deleting old Image

        String oldImageUrl = user.data()!['imageUrl'];
        if (oldImageUrl !=
            "https://firebasestorage.googleapis.com/v0/b/smartplaner-b98ed.appspot.com/o/users%2Fdefault.jpg?alt=media&token=324882eb-149c-4e68-b097-b415a3da8e08") {
          var oldImageRef = FirebaseStorage.instance.refFromURL(oldImageUrl);
          await oldImageRef.delete();
        }
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
    }

    await user.reference.update({
      "displayName": displayNamedTextEditingController.text,
      "phoneNumber": numeroTextEditingController.text,
    });

    isLoading.value = false;
  }
}
