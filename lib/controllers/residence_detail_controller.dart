import 'package:get/get.dart';
import 'package:smart_planner_agent_app/controllers/agents_fetcher.dart';
import 'package:smart_planner_agent_app/controllers/commande_fetcher.dart';
import 'package:smart_planner_agent_app/models/chambre.dart';
import 'package:smart_planner_agent_app/models/residence.dart';

final AgentsFetcher agentFetcherController = Get.find();
final CommandeFetcher commandeFetcher = Get.find();

class ResidenceDetailController extends GetxController {
  Rx<Residence> residence = Residence(
      uid: [],
      image: "",
      name: "",
      address: "",
      phoneNumber: "",
      chambres: []).obs;
  RxList<Chambre> chambres = <Chambre>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(residence, (residence) {
      agentFetcherController.residence.value = (residence as Residence);
      commandeFetcher.residence.value = (residence as Residence);
    });
  }
}
