import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/navigator_controller.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/commandes/commandes_list.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/messaging/messagerie_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/more/more_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/profile_page.dart';
import 'package:smart_planner_agent_app/widgets/logout_appbar.dart';

class HomePage extends GetView<NavigatorController> {
  HomePage({Key? key}) : super(key: key);

  static const id = "/home_page";

  List<Widget> pages = [CommandeList(), MessageriePage(), MorePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoutAppBar(),
      body: Obx(
          () => IndexedStack(children: pages, index: controller.index.value)),
      bottomNavigationBar: CustomBottomNavigationBar(),
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
          currentIndex: _navigatorController.index.value,
          onTap: (index) {
            _navigatorController.index.value = index;
          },
          items: const [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                label: "Messagerie", icon: Icon(Icons.message)),
            BottomNavigationBarItem(label: "plus", icon: Icon(Icons.add))
          ]),
    );
  }
}
