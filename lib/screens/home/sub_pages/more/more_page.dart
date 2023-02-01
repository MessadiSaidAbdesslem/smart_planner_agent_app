import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/edit_personnal_info.dart';
import 'package:smart_planner_agent_app/screens/auth/login/login_page.dart';
import 'package:smart_planner_agent_app/screens/availability/availability_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/editPersonnelInfo/edit_personnel_info.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/profile_page.dart';
import 'package:smart_planner_agent_app/widgets/custom_list_tile.dart';
import 'package:sizer/sizer.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      const SizedBox(height: 14, width: double.infinity),
      CustomListTile(
        icon: Icons.person,
        text: "Profile",
        onPressed: () {
          EditPersonnalInfoController infoController = Get.find();
          infoController.clearAll();
          Get.toNamed(ProfilePage.id);
        },
      ),
      CustomListTile(
          text: "Mes disponibilités",
          icon: Icons.calendar_month,
          onPressed: () {
            Get.toNamed(AvailabilityPage.id);
          }),
      CustomListTile(
        icon: Icons.logout,
        text: "Déconnection",
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          Get.offAllNamed(LoginPage.id);
        },
      ),
    ]);
  }
}
