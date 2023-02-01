import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/controllers/edit_personnal_info.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/editPersonnelInfo/edit_personnel_info.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/rolePage/role_page.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  static const id = "/profile_page";
  final AuthController authController = Get.find();

  final currentUserSnapshots = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RRAppBar("Profile", actions: [
        IconButton(
            onPressed: () {
              EditPersonnalInfoController infoController = Get.find();
              infoController.clearAll();
              Get.toNamed(EditPersonnelInfoPage.id);
            },
            icon: const Icon(Icons.settings))
      ]),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: currentUserSnapshots,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return ErrorMessageWidget(error: snapshot.error.toString());
              }
              if (snapshot.hasData && snapshot.data != null) {
                Agent agent = Agent.fromMap(snapshot.data!.data()!);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(width: double.infinity),
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            height: 100,
                            width: 100,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(500)),
                            child:
                                Image.network(agent.imageUrl, fit: BoxFit.fill),
                          ),
                          Positioned(
                              height: 25,
                              width: 25,
                              bottom: 12,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                      radius: 10,
                                      title: "Modifier votre status",
                                      middleText:
                                          "Voullez-vous modifier votre status ?",
                                      confirm: PrimaryButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(agent.uid)
                                                .update({"isAvailable": true});
                                            Get.back();
                                          },
                                          child: const Text("Disponible")),
                                      cancel: PrimaryButton(
                                          isSecondary: true,
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(agent.uid)
                                                .update({"isAvailable": false});
                                            Get.back();
                                          },
                                          child: const Text("Indisponible")));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 5),
                                      borderRadius: BorderRadius.circular(20),
                                      color: agent.isAvailable
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ))
                        ],
                      ),
                      Text(
                        agent.displayName,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RolePage.id,
                              arguments: {'id': agent.uid});
                        },
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Text(
                            agent.role ?? "N/A",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            }

            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

class NameOfInviter extends StatelessWidget {
  NameOfInviter({
    Key? key,
    required this.inviterId,
  }) : super(key: key);

  String inviterId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future:
            FirebaseFirestore.instance.collection('users').doc(inviterId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorMessageWidget(error: snapshot.error.toString());
            }
            if (snapshot.hasData && snapshot.data != null) {
              Agent inviter = Agent.fromMap(snapshot.data!.data()!);

              return Text(
                inviter.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            }
          }

          return const CircularProgressIndicator();
        });
  }
}
