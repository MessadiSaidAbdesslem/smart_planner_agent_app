import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/navigator_controller.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/commandes/commandes_list.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/more/more_page.dart';
import 'package:smart_planner_agent_app/screens/invitationPage/invitation_page.dart';
import 'package:smart_planner_agent_app/utils/constants.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';

class HomePage extends GetView<NavigatorController> {
  HomePage({Key? key}) : super(key: key);

  final NavigatorController navigatorController = Get.find();
  static const id = "/home_page";

  List<Widget> pages = [CommandeList(), MorePage()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: RRAppBar(
          navigatorController.index.value == 0
              ? "Commande"
              : navigatorController.index.value == 1
                  ? "Messagerie"
                  : "",
          isHome: true,
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
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("invitation")
                              .where("invited",
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
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
        ),
        body: Obx(
            () => IndexedStack(children: pages, index: controller.index.value)),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  final NavigatorController _navigatorController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
          selectedItemColor: Constants.primaryColor,
          currentIndex: _navigatorController.index.value,
          onTap: (index) {
            _navigatorController.index.value = index;
          },
          items: const [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: "plus", icon: Icon(Icons.add))
          ]),
    );
  }
}
