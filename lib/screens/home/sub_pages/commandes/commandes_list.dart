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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Commandes courantes:"),
            ),
          ],
        ),
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
                    return const Expanded(
                      child: Center(
                        child: Text("Vous n'avez aucune commande courante"),
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
        height: 200,
        width: 90.w,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        child: Stack(children: [
          ResidenceDataWidget(groupe: groupe),
          Positioned(
            top: 50,
            left: 45.w - 50,
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularStepProgressIndicator(
                padding: 0,
                selectedColor: Colors.green,
                unselectedColor: Colors.grey[200],
                selectedStepSize: 22,
                stepSize: 20,
                roundedCap: (_, __) => true,
                totalSteps:
                    groupe.chambers.isEmpty ? 1 : groupe.chambers.length,
                currentStep: groupe.chambers.isEmpty ? 0 : tempMap.length,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$percent %',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                    SizedBox(height: 1.w),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            child: Text(groupe.date),
            bottom: 10,
            right: 5.w,
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
                  residence.image != ''
                      ? Image.network(residence.image)
                      : const Placeholder(),
                  Positioned(
                    child: Text(residence.name),
                    top: 10,
                    left: 5.w,
                  )
                ],
              );
            }
          }

          return const Center(child: CircularProgressIndicator());
        });
  }
}
