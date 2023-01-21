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
      appBar: AppBar(title: const Text("Profile")),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                EditPersonnalInfoController infoController =
                                    Get.find();
                                infoController.clearAll();
                                Get.toNamed(EditPersonnelInfoPage.id);
                              },
                              icon: const Icon(Icons.settings))
                        ],
                      ),
                      const SizedBox(
                        width: double.infinity,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.w, bottom: 5.w),
                        height: 200,
                        width: 200,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(500)),
                        child: Image.network(agent.imageUrl, fit: BoxFit.fill),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("status : "),
                              GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                      title: "Modifier votre status",
                                      middleText:
                                          "Voullez-vous modifier votre status ?",
                                      confirm: ElevatedButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(agent.uid)
                                                .update({"isAvailable": true});
                                            Get.back();
                                          },
                                          child: const Text("Disponible")),
                                      cancel: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.red)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: agent.isAvailable
                                          ? Colors.green
                                          : Colors.red),
                                  child: Text(
                                    agent.isAvailable
                                        ? "disponible"
                                        : "Indisponible",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                      ),
                      Text(
                        agent.displayName,
                        style: const TextStyle(fontSize: 24),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Row(
                          children: [
                            const Text("Role: "),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(RolePage.id);
                              },
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white),
                                child: Text(agent.role ?? "N/A"),
                              ),
                            )
                          ],
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

              return Text(inviter.displayName);
            }
          }

          return const CircularProgressIndicator();
        });
  }
}
