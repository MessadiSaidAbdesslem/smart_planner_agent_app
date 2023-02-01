import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/profile_page.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({Key? key}) : super(key: key);
  static const id = "/invitations";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RRAppBar("Invitations"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(height: 14, width: double.infinity),
          InvitationRows(),
        ],
      ),
    );
  }
}

class InvitationRows extends StatelessWidget {
  const InvitationRows({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("invitation")
            .where("invited", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data != null) {
              List<Widget> widgets = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                widgets.add(Container(
                  height: 52,
                  width: min(80.w, 600),
                  margin: const EdgeInsets.symmetric(vertical: 7),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10)
                      ]),
                  child: Row(
                    children: [
                      NameOfInviter(
                          inviterId: snapshot.data!.docs[i].data()['inviter']),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          Get.defaultDialog(
                              radius: 10,
                              title: "Invitation",
                              middleText:
                                  "Voullez vous accepter cette invitation (role: ${snapshot.data!.docs[i].data()['role']}) ?",
                              confirm: PrimaryButton(
                                  onPressed: () async {
                                    var res = await FirebaseFunctions.instance
                                        .httpsCallable("handleInvitation")
                                        .call({
                                      "accept": true,
                                      "invitationId": snapshot.data!.docs[i].id
                                    });
                                    Get.back();
                                  },
                                  child: const Text("Accepter")),
                              cancel: PrimaryButton(
                                  isSecondary: true,
                                  onPressed: () async {
                                    var res = await FirebaseFunctions.instance
                                        .httpsCallable("handleInvitation")
                                        .call({
                                      "accept": false,
                                      "invitationId": snapshot.data!.docs[i].id
                                    });
                                    Get.back();
                                  },
                                  child: const Text("Refuser")));
                        },
                        icon: const Icon(
                          Icons.person_outline_sharp,
                          color: Constants.primaryColor,
                          size: 24,
                        ),
                      )
                    ],
                  ),
                ));
              }
              if (widgets.isNotEmpty) {
                widgets.insert(
                    0,
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Invitations :"),
                    ));
              } else {
                widgets.add(
                  Column(
                    children: [
                      Image.asset("assets/empty.png"),
                      const Text(
                        "Vous n'avez aucune commande courante",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }

              return Expanded(
                  child:
                      SingleChildScrollView(child: Column(children: widgets)));
            }
          }

          return Container();
        });
  }
}
