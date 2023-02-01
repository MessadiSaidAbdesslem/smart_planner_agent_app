import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/agents_fetcher.dart';
import 'package:smart_planner_agent_app/controllers/residence_detail_controller.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/models/chambre.dart';
import 'package:smart_planner_agent_app/models/commande.dart';
import 'package:smart_planner_agent_app/models/groupe.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/messaging/chat_page.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/custom_card.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';

class ControlPage extends StatelessWidget {
  ControlPage({Key? key}) : super(key: key);

  static const id = "/controle";
  final ResidenceDetailController residenceController = Get.find();
  final AgentsFetcher agentsFetcher = Get.find();

  final groupSnapshots = FirebaseFirestore.instance
      .collection("groups")
      .doc(Get.arguments['groupId'])
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RRAppBar("Contrôle"),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(height: 14, width: double.infinity),
        SizedBox(
          width: min(600, 80.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    residenceController.residence.value.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Constants.primaryColor),
                  )),
              Text(DateFormat('dd/MM/yyyy').format(DateTime.now()))
            ],
          ),
        ),
        SizedBox(
          width: min(600, 80.w),
          child: Row(
            children: const [
              Text("Liste du personnel assigné:",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
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
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                          children: widgets +
                              (commandeFetcher.allRooms.value.isEmpty
                                  ? []
                                  : [])),
                    ),
                  );
                });
              }

              return const Center(child: CircularProgressIndicator());
            })),
        const SizedBox(height: 14),
        PrimaryButton(
            onPressed: () {
              Get.toNamed(ChatPage.id, arguments: {
                'roomid': Get.arguments['groupId'],
                'roomname': "Messages"
              });
            },
            child: const Text("Messages")),
        const SizedBox(height: 14),
      ]),
    );
  }
}

class ChamberRow extends StatelessWidget {
  ChamberRow(
      {Key? key,
      required this.chamber,
      required this.chamberState,
      required this.groupe})
      : super(key: key) {
    commandeStream = FirebaseFirestore.instance
        .collection("commande")
        .where("date",
            isEqualTo: DateTime.now().toIso8601String().substring(0, 10))
        .where('requestedRooms', arrayContains: chamber.id)
        .snapshots();
  }

  Chambre chamber;
  String? chamberState;
  Groupe groupe;
  late Stream<QuerySnapshot<Map<String, dynamic>>> commandeStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: commandeStream,
        builder: (context, snapshot) {
          Commande commande;
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.docs.isNotEmpty) {
            commande = Commande.fromMap(snapshot.data?.docs[0].data() ?? {});
          } else {
            commande = Commande(
              addedRooms: LinkedHashMap(),
              created: true,
              deletedRooms: LinkedHashMap(),
              priorityRooms: [],
              date: "",
              requestedRooms: [],
              residence: [],
              roomsAvailable: LinkedHashMap(),
            );
          }
          return GestureDetector(
            onTap: () {
              Get.defaultDialog(
                  radius: 10,
                  title: '',
                  titleStyle: const TextStyle(fontSize: 0),
                  titlePadding: EdgeInsets.zero,
                  contentPadding: EdgeInsetsDirectional.zero,
                  content: StreamBuilder<String>(
                      stream: FirebaseFirestore.instance
                          .collection("groups")
                          .doc(groupe.id)
                          .snapshots()
                          .transform<String>(StreamTransformer.fromHandlers(
                              handleData: (data, sink) {
                        Groupe group = Groupe.fromMap(data.data()!);
                        sink.add(group.chambersState[chamber.id] ?? "");
                      })),
                      builder: (context, snapshot) {
                        print("-------------");
                        print(snapshot.data);
                        if (snapshot.hasData && snapshot.data != null) {
                          return Column(
                            children: [
                              SizedBox(
                                  height: 52,
                                  child: CustomCard(
                                      isElevated: true,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            chamber.numero,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          (commande.roomsAvailable[
                                                      chamber.id] ??
                                                  false)
                                              ? const Text(
                                                  "Libre",
                                                  style: TextStyle(
                                                      color: Constants
                                                          .primaryColor),
                                                )
                                              : const Text(
                                                  "Occupé",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                          Text(chamber.typologie)
                                        ],
                                      ))),
                              const SizedBox(height: 14),
                              SizedBox(
                                child: DropdownButton<String>(
                                    value: snapshot.data ?? Groupe.retour,
                                    underline: Container(),
                                    items: [
                                      const DropdownMenuItem<String>(
                                          value: "", child: Text("")),
                                      DropdownMenuItem<String>(
                                          value: Groupe.retour,
                                          child: SizedBox(
                                            width: min(450, 60.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.error_outline,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 20),
                                                Text(
                                                  "Retour",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ],
                                            ),
                                          )),
                                      DropdownMenuItem<String>(
                                          value: Groupe.menageOK,
                                          child: SizedBox(
                                            width: min(450, 60.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Image.asset(
                                                      'assets/cleaning-ok.png'),
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  "Ménage Ok",
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.7)),
                                                )
                                              ],
                                            ),
                                          )),
                                      DropdownMenuItem<String>(
                                          value: Groupe.controlOK,
                                          child: SizedBox(
                                            width: min(450, 60.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  width: 30,
                                                  child: Image.asset(
                                                      'assets/control-ok.png'),
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  "Contrôle Ok",
                                                  style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(0.7)),
                                                )
                                              ],
                                            ),
                                          )),
                                    ],
                                    onChanged: (value) async {
                                      if (value != null && value != "") {
                                        var chambersState =
                                            groupe.chambersState;
                                        chambersState[chamber.id ?? "-1"] =
                                            value;

                                        await FirebaseFirestore.instance
                                            .collection("groups")
                                            .doc(groupe.id)
                                            .update({
                                          "chambersState": chambersState
                                        });
                                      }
                                    }),
                              )
                            ],
                          );
                        }
                        return Container();
                      }));
            },
            child: Container(
                height: 52,
                width: min(80.w, 600),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, color: Colors.black.withOpacity(0.05))
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: commande.roomsAvailable[chamber.id] != null
                              ? ((commande.roomsAvailable[chamber.id]!)
                                  ? const BorderSide(
                                      color: Constants.primaryColor, width: 3)
                                  : const BorderSide(
                                      color: Colors.red, width: 3))
                              : const BorderSide(
                                  color: Colors.grey, width: 3))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: min(20.w, 150),
                          child: Center(
                            child: Text(
                              chamber.numero,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                      SizedBox(
                          width: min(20.w, 150),
                          child: Center(
                              child: Text(
                                  commande.priorityRooms.contains(chamber.id)
                                      ? "Prioritaire"
                                      : ""))),
                      SizedBox(
                          width: min(20.w, 150),
                          child: Center(child: Text(chamber.typologie))),
                      SizedBox(
                        height: 52,
                        width: min(20.w, 150) - 3,
                        child: Center(
                            child: SizedBox(
                          width: 30,
                          child: chamberState == Groupe.retour
                              ? const Icon(Icons.error_outline,
                                  color: Colors.red)
                              : chamberState == Groupe.menageOK
                                  ? Image.asset("assets/cleaning-ok.png")
                                  : chamberState == Groupe.controlOK
                                      ? Image.asset("assets/control-ok.png")
                                      : const Icon(Icons.toc,
                                          color: Colors.grey),
                        )),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}

class RoomStateWidget extends StatelessWidget {
  const RoomStateWidget({
    Key? key,
    required this.chamber,
  }) : super(key: key);

  final Chambre chamber;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("commande")
          .where("date",
              isEqualTo: DateTime.now().toIso8601String().substring(0, 10))
          .where('requestedRooms', arrayContains: chamber.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.docs.isNotEmpty) {
            return Row(
              children: [
                SizedBox(
                  width: 20.w,
                  child: (snapshot.data!.docs[0].data()['roomsAvailable']
                              [chamber.id ?? "a"] !=
                          null
                      ? snapshot.data!.docs[0].data()['roomsAvailable']
                              [chamber.id ?? "a"]
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Constants.primaryColor),
                              child: const Text("Libre",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white)),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red),
                              child: const Text("Occupé",
                                  style: TextStyle(color: Colors.white)),
                            )
                      : const Text("N/A")),
                ),
                SizedBox(width: 2.w),
                (snapshot.data!.docs[0].data()['priorityRooms']
                                as List<dynamic>? ??
                            [])
                        .contains(chamber.id!)
                    ? SizedBox(
                        width: 20.w,
                        child: const Text("Prioritaire",
                            style: TextStyle(color: Colors.red)),
                      )
                    : Container(width: 20.w)
              ],
            );
          }
        }

        return SizedBox(width: 42.w, child: const Text("N/A"));
      },
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
      width: min(40.w, 300) - 16,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
          ],
          color: Colors.white),
      child: Column(children: [
        SizedBox(
            width: min(20.w, 300) - 16,
            child: Text(
              agent.displayName,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        const Spacer(),
        SizedBox(
            width: min(20.w, 300) - 16,
            child: Text(
              agent.role ?? "N/A",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: TextStyle(color: Colors.black.withOpacity(0.5)),
            )),
      ]),
    );
  }
}
