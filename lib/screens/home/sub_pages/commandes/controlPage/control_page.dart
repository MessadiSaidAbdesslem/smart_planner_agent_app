import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/agents_fetcher.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/controllers/commande_fetcher.dart';
import 'package:smart_planner_agent_app/controllers/residence_detail_controller.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/models/chambre.dart';
import 'package:smart_planner_agent_app/models/commande.dart';
import 'package:smart_planner_agent_app/models/groupe.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';

class ControlPage extends StatelessWidget {
  ControlPage({Key? key}) : super(key: key);

  static const id = "/controle";
  final ResidenceDetailController residenceController = Get.find();
  final AgentsFetcher agentsFetcher = Get.find();

  final CommandeFetcher commandeFetcher = Get.find();

  final groupSnapshots = FirebaseFirestore.instance
      .collection("groups")
      .doc(Get.arguments['groupId'])
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contrôle"),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => Text(
                      residenceController.residence.value.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(DateTime.now().toString().substring(0, 10)),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Liste du personnel assigné:"),
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: groupSnapshots,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasError) {
                    return ErrorMessageWidget(error: snapshot.error.toString());
                  }
                  if (snapshot.hasData && snapshot.data != null) {
                    return Obx(
                      () {
                        Groupe groupe = Groupe.fromMap(snapshot.data!.data()!);
                        List<Widget> widgets = [];

                        for (int i = 0; i < groupe.members.length; i++) {
                          String currentId = groupe.members[i];

                          Agent? currentMember =
                              agentsFetcher.agentsMap[currentId];

                          if (currentMember == null) {
                            widgets.add(const Center(
                              child: CircularProgressIndicator(),
                            ));
                          } else {
                            widgets.add(AgentChip(agent: currentMember));
                          }
                        }

                        return Wrap(
                            children: widgets +
                                (agentsFetcher.agentsMap.isEmpty ? [] : []));
                      },
                    );
                  }
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              })),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StateChip(
                color: Colors.red,
                label: "Retour",
              ),
              const SizedBox(width: 10),
              StateChip(
                color: const Color(0xff6A60DC),
                label: "Ménage OK",
              ),
              const SizedBox(width: 10),
              StateChip(
                color: Colors.green,
                label: "Contrôle OK",
              ),
              const SizedBox(width: 10),
            ],
          ),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: groupSnapshots,
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessageWidget(error: snapshot.error.toString());
                }

                if (snapshot.hasData && snapshot.data != null) {
                  return Obx(() {
                    Groupe groupe = Groupe.fromMap(snapshot.data!.data()!);

                    List<String> chambersList = groupe.chambers;
                    List<Widget> widgets = [];
                    for (int i = 0; i < chambersList.length; i++) {
                      String currentId = chambersList[i];
                      Chambre? currentChambre =
                          commandeFetcher.allRooms.value[currentId];

                      if (currentChambre == null) {
                        widgets.add(
                            const Center(child: CircularProgressIndicator()));
                      } else {
                        widgets.add(ChamberRow(
                          groupe: groupe,
                          chamberState: groupe.chambersState[currentChambre.id],
                          chamber: currentChambre,
                        ));
                      }
                    }
                    return Column(
                        children: commandeFetcher.allRooms.isEmpty
                            ? widgets
                            : widgets);
                  });
                }

                return const Center(child: CircularProgressIndicator());
              })),
        ]),
      ),
    );
  }
}

class ChamberRow extends StatelessWidget {
  ChamberRow(
      {Key? key,
      required this.chamber,
      required this.chamberState,
      required this.groupe})
      : super(key: key);
  final AuthController authController = Get.find();

  Chambre chamber;
  String? chamberState;
  Groupe groupe;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(chamber.numero),
            Text(chamber.typologie),
            Obx(
              () => GestureDetector(
                onTap: !authController.isSuperVisor.value
                    ? () {
                        Get.showSnackbar(const GetSnackBar(
                          backgroundColor: Colors.red,
                          messageText: Text(
                            "Vous ne pouvez pas modifier l'état",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                        Future.delayed(const Duration(seconds: 3))
                            .then((value) => Get.closeAllSnackbars());
                      }
                    : (groupe.chambersState[chamber.id] == null ||
                                groupe.chambersState[chamber.id] == "" ||
                                groupe.chambersState[chamber.id] ==
                                    Groupe.retour) &&
                            authController.isSuperVisor.value
                        ? () async {
                            Get.defaultDialog(
                                title: "Le ménage est-il fini ?",
                                middleText:
                                    "Voulez-vous confirmer la fin du ménage ?",
                                confirm: ElevatedButton(
                                    onPressed: () async {
                                      var chambersState = groupe.chambersState;

                                      chambersState[chamber.id ?? "-1"] =
                                          Groupe.menageOK;

                                      await FirebaseFirestore.instance
                                          .collection("groups")
                                          .doc(groupe.id)
                                          .update(
                                              {"chambersState": chambersState});
                                      Get.back();
                                    },
                                    child: const Text("Oui")),
                                cancel: OutlinedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text("Non")));
                          }
                        : () async {},
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: chamberState == Groupe.retour
                        ? Colors.red
                        : chamberState == Groupe.menageOK
                            ? const Color(0xff6A60DC)
                            : chamberState == Groupe.controlOK
                                ? Colors.green
                                : Colors.grey,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

class StateChip extends StatelessWidget {
  StateChip({
    required this.color,
    required this.label,
    Key? key,
  }) : super(key: key);

  Color color;
  String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 6),
          ),
        ),
      ],
    );
  }
}

class AgentChip extends StatelessWidget {
  const AgentChip({
    Key? key,
    required this.agent,
  }) : super(key: key);

  final Agent agent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
      width: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Row(children: [
        SizedBox(
            width: 14.w,
            child: Text(
              agent.displayName,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
            )),
        const Spacer(),
        SizedBox(
            width: 14.w,
            child: Text(
              agent.role ?? "N/A",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: const TextStyle(color: Color(0xff6490E4)),
            )),
      ]),
    );
  }
}
