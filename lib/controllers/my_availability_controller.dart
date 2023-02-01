import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/widgets/primary_button.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyAvailabilityController extends GetxController {
  late Rx<CustomCalendarDataSource> events;
  final CalendarController calendarController = CalendarController();

  List<Color> colors = [
    const Color(0xFF0F8644),
    const Color(0xFF8B1FA9),
    const Color(0xFFD20100),
    const Color(0xFFFC571D),
    const Color(0xFF85461E),
    const Color(0xFF36B37B),
    const Color(0xFF3D4FB5),
    const Color(0xFFE47C73),
    const Color(0xFF636363)
  ];

  @override
  void onInit() {
    super.onInit();
    calendarController.view = CalendarView.month;
    events = CustomCalendarDataSource([]).obs;
    loadData();
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    var res = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Agent agent = Agent.fromMap(res.data()!);
    List<MapEntry<String, bool>> timings = agent.availability.entries.toList();
    List<Appointment> source = [];
    for (int j = 0; j < timings.length; j++) {
      MapEntry<String, bool> currentTiming = timings[j];
      DateTime startTime = DateTime.parse(currentTiming.key);
      source.add(Appointment(
          subject: '',
          color: currentTiming.value ? Colors.green : Colors.red,
          resourceIds: [agent.uid],
          startTime: startTime,
          endTime: startTime.add(const Duration(hours: 12))));
    }

    events.value = CustomCalendarDataSource(source);
  }

  void onTap(CalendarTapDetails details) {
    if (details.date != null) {
      DateTime currentDate = details.date!;

      // load all the appointements into a LinkedhashMap for updating later
      var appointements =
          (events.value.appointments?.toList() as List<Appointment>?) ??
              <Appointment>[];

      Map<String, bool> appointementsMap = <String, bool>{};

      for (int i = 0; i < appointements.length; i++) {
        var currentAppointement = appointements[i];
        appointementsMap[currentAppointement.startTime.toString()] =
            currentAppointement.color == Colors.green;
      }

      NumberFormat formatter = NumberFormat("00");
      var selectedDate = formatter.format(details.date!.day) +
          '-' +
          formatter.format(details.date!.month) +
          '-' +
          details.date!.year.toString();

      Get.defaultDialog(
          radius: 10,
          title: "Disponible ?",
          middleText:
              "Veuillez SVP précisez votre disponibilité pour la date suivante : $selectedDate",
          confirm: PrimaryButton(
            onPressed: () async {
              appointementsMap[currentDate.toString()] = true;
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({"availability": appointementsMap},
                      SetOptions(merge: true));
              loadData();
              Get.back();
            },
            child: const Text(
              "Disponible",
              style: TextStyle(color: Colors.white),
            ),
          ),
          cancel: PrimaryButton(
              isSecondary: true,
              onPressed: () async {
                appointementsMap[currentDate.toString()] = false;
                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({"availability": appointementsMap},
                        SetOptions(merge: true));
                loadData();
                Get.back();
              },
              child: const Text(
                "Indisponible",
              )));
    }
  }
}

class CustomCalendarDataSource extends CalendarDataSource {
  CustomCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}
