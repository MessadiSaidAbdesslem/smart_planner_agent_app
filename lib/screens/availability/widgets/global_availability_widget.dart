import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';

class GlobalStatusAvailability extends StatelessWidget {
  GlobalStatusAvailability({Key? key, required this.stream}) : super(key: key);

  Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return ErrorMessageWidget(error: snapshot.error.toString());
            }
            if (snapshot.hasData && snapshot.data != null) {
              Agent agent = Agent.fromMap(snapshot.data!.data()!);
              return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.defaultDialog(
                              radius: 10,
                              title: "Statut globale",
                              middleText:
                                  "La valeur par défaut si vous ne spécifié pas une disponibilité pour un jour.");
                        },
                        icon: const Icon(Icons.info_outline)),
                    const Text("Status globale : "),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                            radius: 10,
                            title: "Modifier votre status",
                            middleText: "Voullez-vous modifier votre status ?",
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
                        height: 12,
                        width: 12,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                agent.isAvailable ? Colors.green : Colors.red),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                            radius: 10,
                            title: "Modifier votre status",
                            middleText: "Voullez-vous modifier votre status ?",
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
                      child: Text(
                        agent.isAvailable ? "disponible" : "Indisponible",
                        style: TextStyle(
                            color:
                                agent.isAvailable ? Colors.green : Colors.red),
                      ),
                    ),
                  ]);
            }
          }
          return const CircularProgressIndicator();
        });
  }
}
