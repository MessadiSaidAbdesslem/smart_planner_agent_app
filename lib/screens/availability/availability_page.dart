import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/my_availability_controller.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/screens/availability/widgets/global_availability_widget.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AvailabilityPage extends GetView<MyAvailabilityController> {
  AvailabilityPage({Key? key}) : super(key: key);

  static const id = "/my_availability_page";

  final currentUserSnapshots = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RRAppBar("Mes disponibilités"),
      body: Column(children: [
        GlobalStatusAvailability(stream: currentUserSnapshots),
        Obx(
          () => SfCalendar(
            dataSource: controller.events.value,
            controller: controller.calendarController,
            onTap: controller.onTap,
          ),
        )
      ]),
    );
  }
}
