import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/residence_detail_controller.dart';
import 'package:smart_planner_agent_app/models/groupe.dart';
import 'package:smart_planner_agent_app/models/residence.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/commandes/controlPage/control_page.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CommandeList extends StatelessWidget {
  CommandeList({Key? key}) : super(key: key);

  final AuthController authController = Get.find();

  final currentUserGroupsSnapshot = FirebaseFirestore.instance
      .collection("groups")
      .where("members", arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .where("date",
          isEqualTo: DateFormat.yMd().format(DateTime.now()).toString())
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 14, width: double.infinity),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: currentUserGroupsSnapshot,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasError) {
                  return ErrorMessageWidget(error: snapshot.error.toString());
                }
                if (snapshot.hasData && snapshot.data != null) {
                  List<Widget> widgets = snapshot.data!.docs.map((doc) {
                    Groupe groupe = Groupe.fromMap(doc.data())..id = doc.id;

                    return CommandeCard(groupe: groupe);
                  }).toList();

                  if (widgets.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset("assets/empty.png"),
                            const Text("Vous n'avez aucune commande courante"),
                          ],
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                      child: Column(children: widgets));
                }
              }
              return const Center(child: CircularProgressIndicator());
            })
      ],
    );
  }
}

class CommandeCard extends StatelessWidget {
  CommandeCard({
    Key? key,
    required this.groupe,
  }) : super(key: key);

  final ResidenceDetailController residenceDetailController = Get.find();

  final Groupe groupe;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> tempMap = Map.from(groupe.chambersState);
    tempMap.removeWhere(
        (key, value) => value == Groupe.retour || value == null || value == "");
    int percent = tempMap.isEmpty
        ? 0
        : (tempMap.length / groupe.chambersState.length * 100).toInt();

    DateFormat formatter = DateFormat("dd/MM/yyyy");
    String todaysDate = formatter.format(DateTime(
        int.parse(groupe.date.split('/')[2]),
        int.parse(groupe.date.split('/')[0]),
        int.parse(groupe.date.split('/')[1])));

    return GestureDetector(
      onTap: () async {
        var res = await FirebaseFirestore.instance
            .collection("residence")
            .doc(groupe.idResidence)
            .get();

        Residence residence = Residence.fromMapFirebase(res.data()!);

        residenceDetailController.residence.value = residence;

        Get.toNamed(ControlPage.id, arguments: {"groupId": groupe.id});
      },
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: 175,
        width: min(80.w, 600),
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 5))
            ]),
        child: Stack(children: [
          ResidenceDataWidget(groupe: groupe),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              SizedBox(
                height: 100,
                width: 100,
                child: CircularStepProgressIndicator(
                  padding: 0,
                  selectedColor: Colors.white,
                  unselectedColor: Colors.white.withOpacity(0.2),
                  selectedStepSize: 30,
                  stepSize: 20,
                  roundedCap: (_, __) => false,
                  totalSteps:
                      groupe.chambers.isEmpty ? 1 : groupe.chambers.length,
                  currentStep: groupe.chambers.isEmpty ? 0 : tempMap.length,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$percent %',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 5),
                Text(
                  todaysDate,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            bottom: 10,
            right: min(5.w, 37.5),
          )
        ]),
      ),
    );
  }
}

class ResidenceDataWidget extends StatelessWidget {
  const ResidenceDataWidget({
    Key? key,
    required this.groupe,
  }) : super(key: key);

  final Groupe groupe;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection("residence")
            .doc(groupe.idResidence)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorMessageWidget(error: snapshot.error.toString());
            }
            if (snapshot.hasData && snapshot.data != null) {
              Residence residence =
                  Residence.fromMapFirebase(snapshot.data!.data()!);

              return Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      residence.image != ''
                          ? Image.network(residence.image)
                          : Image.asset("assets/placeholder.png"),
                      const SizedBox(height: double.infinity)
                    ],
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.black.withOpacity(0.5),
                  )),
                  Positioned(
                    child: Text(residence.name,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    bottom: 10,
                    left: min(5.w, 37.5),
                  )
                ],
              );
            }
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
