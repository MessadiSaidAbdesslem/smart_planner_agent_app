import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:smart_planner_agent_app/models/chambre.dart';
import 'package:smart_planner_agent_app/models/commande.dart';
import 'package:smart_planner_agent_app/models/residence.dart';

class CommandeFetcher extends GetxController {
  RxSet<String> requestedRooms = <String>{}.obs;
  Rx<Residence> residence = Residence(
      uid: [],
      image: "",
      name: "",
      address: "",
      phoneNumber: "",
      chambres: []).obs;

  RxMap<String, Chambre> allRooms = <String, Chambre>{}.obs;

  @override
  void onInit() {
    super.onInit();
    ever(residence, (value) async {
      requestedRooms.clear();
      requestedRooms.refresh();
      // date formatted in this format YYYY-MM-DD
      String today = DateTime.now().year.toString() +
          "-" +
          DateTime.now().month.toString() +
          "-" +
          DateTime.now().day.toString();

      (value as Residence);

      var res = await FirebaseFirestore.instance
          .collection("commande")
          .where("residence", arrayContainsAny: [(value.id ?? "-1")])
          .where("date", isEqualTo: today)
          .get();

      for (int i = 0; i < res.docs.length; i++) {
        var doc = res.docs[i];
        doc.data();
        Commande commande = Commande.fromMap(doc.data());

        for (int j = 0; j < commande.requestedRooms.length; j++) {
          requestedRooms.add(commande.requestedRooms[j]);
          requestedRooms.refresh();
        }
      }
      print("REQUESTED ROOMS TODAY:");
      print(requestedRooms);

      for (int i = 0; i < residence.value.chambres.length; i++) {
        String currentId = residence.value.chambres[i];
        var res = await FirebaseFirestore.instance
            .collection("chambre")
            .doc(currentId)
            .get();

        allRooms.value[currentId] = Chambre.fromMapFirebase(res.data() ?? {})
          ..id = currentId;

        allRooms.refresh();
      }

      print("ALL ROOMS");
      print(allRooms);
    });
  }
}
