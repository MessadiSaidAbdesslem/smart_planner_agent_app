import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/navigator_controller.dart';
import 'package:smart_planner_agent_app/screens/invitationPage/invitation_page.dart';

import '../screens/auth/login/login_page.dart';

PreferredSizeWidget LogoutAppBar() {
  NavigatorController navigatorController = Get.find();
  return AppBar(
    title: Obx(
      () => Text(navigatorController.index.value == 0
          ? "Commande"
          : navigatorController.index.value == 1
              ? "Messagerie"
              : ""),
    ),
    actions: [
      IconButton(
          onPressed: () {
            Get.toNamed(InvitationPage.id);
          },
          icon: Stack(
            children: [
              const Icon(Icons.notifications),
              Positioned(
                  right: 0,
                  top: 0,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("invitation")
                        .where("invited",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData && snapshot.data != null) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.red,
                              ),
                              width: 15,
                              height: 15,
                              child: Center(
                                child: Text(
                                  snapshot.data!.size.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 8),
                                ),
                              ),
                            );
                          }
                        }
                      }

                      return Container();
                    },
                  ))
            ],
          ))
    ],
  );
}
