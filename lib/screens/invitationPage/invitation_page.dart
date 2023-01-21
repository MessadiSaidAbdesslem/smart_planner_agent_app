import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/profile_page.dart';
import 'package:sizer/sizer.dart';

class InvitationPage extends StatelessWidget {
  const InvitationPage({Key? key}) : super(key: key);
  static const id = "/invitations";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invitations")),
      body: InvitationRows(),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black)),
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                  child: Row(
                    children: [
                      NameOfInviter(
                          inviterId: snapshot.data!.docs[i].data()['inviter']),
                      const Spacer(),
                      Text(snapshot.data!.docs[i].data()['role']),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          Get.defaultDialog(
                              title: "Invitation",
                              middleText:
                                  "Voullez vous accepter cette invitation (role: ${snapshot.data!.docs[i].data()['role']}) ?",
                              confirm: ElevatedButton(
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
                              cancel: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red)),
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
                        child: const Text("Intéragir"),
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
                widgets.add(const Expanded(
                    child:
                        Center(child: Text("Vous n'avez aucune invitation"))));
              }

              return Column(children: widgets);
            }
          }

          return Container();
        });
  }
}
