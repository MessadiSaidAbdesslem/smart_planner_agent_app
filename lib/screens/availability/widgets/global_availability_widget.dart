import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:sizer/sizer.dart';

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
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                            title: "Statut globale",
                            middleText:
                                "La valeur par défaut si vous ne spécifié pas une disponibilité pour un jour.");
                      },
                      icon: const Icon(Icons.info_outline)),
                  const Text("status globale : "),
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                          title: "Modifier votre status",
                          middleText: "Voullez-vous modifier votre status ?",
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
                                      MaterialStateProperty.all(Colors.red)),
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
                          color: agent.isAvailable ? Colors.green : Colors.red),
                      child: Text(
                        agent.isAvailable ? "disponible" : "Indisponible",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ]),
              );
            }
          }
          return const CircularProgressIndicator();
        });
  }
}
