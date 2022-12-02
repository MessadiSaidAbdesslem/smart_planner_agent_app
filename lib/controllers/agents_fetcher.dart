import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/models/agent.dart';
import 'package:smart_planner_agent_app/models/residence.dart';

class AgentsFetcher extends GetxController {
  RxMap<String, Agent> agentsMap = <String, Agent>{}.obs;
  Rx<Residence> residence = Residence(
      uid: [],
      image: "",
      name: "",
      address: "",
      phoneNumber: "",
      chambres: []).obs;

  @override
  void onInit() {
    super.onInit();
    ever(residence, (value) async {
      print("FETCHING AGENTS--------------------------");
      agentsMap.clear();
      agentsMap.refresh();
      Residence myResidence = (value as Residence);
      String ownerId = myResidence.uid[0];

      var cleaningCompanyOwnerFuture = FirebaseFirestore.instance
          .collection("cleaningCompany")
          .where("ownerId", isEqualTo: ownerId)
          .get();

      var adminsFuture = FirebaseFirestore.instance
          .collection("cleaningCompany")
          .where("admins", arrayContains: ownerId)
          .get();

      var employessFuture = FirebaseFirestore.instance
          .collection("cleaningCompany")
          .where("employees", arrayContains: ownerId)
          .get();

      var res = await Future.wait(
          [cleaningCompanyOwnerFuture, adminsFuture, employessFuture]);
      var data = [];
      if (res[0].docs.isNotEmpty) {
        data = res[0].docs.first.data()["employees"] ?? [];
      } else if (res[1].docs.isNotEmpty) {
        data = res[1].docs.first.data()["employees"] ?? [];
      } else if (res[2].docs.isNotEmpty) {
        data = res[2].docs.first.data()["employees"] ?? [];
      }

      for (int i = 0; i < data.length; i++) {
        var res = await FirebaseFirestore.instance
            .collection("users")
            .doc(data[i])
            .get();

        Agent temp = Agent.fromMap(res.data() ??
            {
              "displayName": "",
              "email": "",
              "imageUrl": "",
              "phoneNumber": "",
              "uid": ""
            });

        agentsMap[data[i]] = temp;
        agentsMap.refresh();
      }
      print(agentsMap.value);
    });
  }
}
