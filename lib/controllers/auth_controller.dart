import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home/home_page.dart';

class AuthController extends GetxController {
  RxSet<String> ownedResidencesIds = <String>{}.obs;

  RxBool isSuperVisor = false.obs;
  RxString currentUserRole = "".obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  RxBool loading = false.obs;

  AuthController();

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        currentUserRole.value = "";
        ownedResidencesIds.value.clear();
        ownedResidencesIds.refresh();
        isSuperVisor.value = false;
      } else {
        var userData = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        isSuperVisor.value = (userData.data()!['supervisor'] as bool?) ?? false;

        var residenceRes = await FirebaseFirestore.instance
            .collection("residence")
            .where("uid", arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .get();

        residenceRes.docs.forEach((element) {
          ownedResidencesIds.add(element.id);
        });
        print("-------------owned Residences-------------");
        print(ownedResidencesIds.value);

        var res = await FirebaseFirestore.instance
            .collection("roles")
            .doc(user.uid)
            .get();
        print(user.uid);
        currentUserRole.value = res.data()!["roles"][0];
        print(currentUserRole);
        FirebaseFirestore.instance
            .collection("users")
            .where("uid", isEqualTo: user.uid)
            .snapshots()
            .listen((event) async {
          print("on user changed called");
          // String imageUrl = event.docs.first.data()["imageUrl"];
          // Uint8List? temp =
          //     await FirebaseStorage.instance.ref().child(imageUrl).getData();
          // if (temp == null) {
          //   // } else {
          //   //   _userController.userImage.value = temp;
          //   //   _userController.imageIsSet.value = true;
          // }
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nomController.dispose();
    prenomController.dispose();
    super.dispose();
  }

  void authenticateWithEmailPassword() async {
    Get.closeAllSnackbars();
    loading.value = true;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      print(credential.user!.uid);
      Get.offAllNamed(HomePage.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        Get.showSnackbar(const GetSnackBar(
          message: "Mot de passe / email erroné",
          duration: Duration(seconds: 2),
        ));
      }
    }
    loading.value = false;
  }

  Future<void> singUpAgent() async {
    loading.value = true;
    var res =
        await FirebaseFunctions.instance.httpsCallable("signUpAgent").call({
      "email": emailController.text,
      "displayName": prenomController.text + " " + nomController.text,
      "password": passwordController.text
    });

    loading.value = false;

    if (res.data['status'] == "success") {
      Get.showSnackbar(const GetSnackBar(
        backgroundColor: Colors.green,
        messageText: Text(
          'Compte créer avec succés',
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      Get.showSnackbar(const GetSnackBar(
        backgroundColor: Colors.red,
        messageText: Text(
          'Une erreure s\'est produit',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }

    Future.delayed(const Duration(seconds: 2))
        .then((value) => Get.closeAllSnackbars());
  }
}
