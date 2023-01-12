import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/controllers/agents_fetcher.dart';
import 'package:smart_planner_agent_app/controllers/auth_controller.dart';
import 'package:smart_planner_agent_app/controllers/commande_fetcher.dart';
import 'package:smart_planner_agent_app/controllers/edit_personnal_info.dart';
import 'package:smart_planner_agent_app/controllers/navigator_controller.dart';
import 'package:smart_planner_agent_app/controllers/residence_detail_controller.dart';
import 'package:smart_planner_agent_app/controllers/role_controller.dart';
import 'package:smart_planner_agent_app/firebase_options.dart';
import 'package:smart_planner_agent_app/screens/auth/login/login_page.dart';
import 'package:smart_planner_agent_app/screens/auth/reset/reset_password.dart';
import 'package:smart_planner_agent_app/screens/auth/signup/signup_page.dart';
import 'package:smart_planner_agent_app/screens/home/home_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/commandes/controlPage/control_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/messaging/chat_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/editPersonnelInfo/edit_personnel_info.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/personaliseRolePage/personalise_role_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/rolePage/role_page.dart';
import 'package:smart_planner_agent_app/screens/splashscreen/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.authStateChanges().first;

  // print('firebase messaging token');
  // print(await FirebaseMessaging.instance.getToken());
  await initializeNotifications();

  runApp(const MyApp());
}

Future<void> initializeNotifications() async {
  if (kIsWeb || Platform.isIOS) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        Get.defaultDialog(
            title: "Nouvelle Mise à jour",
            middleText:
                "Veuillez installer la nouvelle version disponible",
            confirm: ElevatedButton(
                onPressed: () async {
                  await launchUrl(
                      Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.talos.smart_planner_users_app'),
                      mode: LaunchMode.externalApplication);
                },
                child: const Text("Update")));
      }
      FirebaseMessaging.onMessage.listen((event) {
        Get.defaultDialog(
            title: "Nouvelle Mise à jour",
            middleText:
                "Veuillez installer la nouvelle version disponible",
            confirm: ElevatedButton(
                onPressed: () async {
                  await launchUrl(
                      Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.talos.smart_planner_users_app'),
                      mode: LaunchMode.externalApplication);
                },
                child: const Text("Update")));
      });

      FirebaseMessaging.onMessageOpenedApp.listen((event) async {
        await launchUrl(
            Uri.parse(
                'https://play.google.com/store/apps/details?id=com.talos.smart_planner_users_app'),
            mode: LaunchMode.externalApplication);
      });
    }
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        title: 'Smart planner agent',
        getPages: [
          GetPage(name: LoginPage.id, page: () => SafeArea(child: LoginPage())),
          GetPage(
              name: SignupPage.id,
              page: () => const SafeArea(child: SignupPage())),
          GetPage(
              name: ResetPasswordPage.id,
              page: () => SafeArea(child: ResetPasswordPage())),
          GetPage(name: HomePage.id, page: () => SafeArea(child: HomePage())),
          GetPage(
              name: EditPersonnelInfoPage.id,
              page: () => SafeArea(
                    child: EditPersonnelInfoPage(),
                  )),
          GetPage(
              name: ControlPage.id, page: () => SafeArea(child: ControlPage())),
          GetPage(name: RolePage.id, page: () => SafeArea(child: RolePage())),
          GetPage(
              name: PersonaliseRolePage.id,
              page: () => SafeArea(
                    child: PersonaliseRolePage(),
                  )),
          GetPage(name: ChatPage.id, page: () => SafeArea(child: ChatPage())),
          GetPage(name: SplashScreen.id, page: () => SplashScreen())
        ],
        initialBinding: BindingsBuilder(() {
          Get.put(AuthController(), permanent: true);
          Get.put(NavigatorController(), permanent: true);
          Get.put(EditPersonnalInfoController(), permanent: true);
          Get.put(AgentsFetcher(), permanent: true);
          Get.put(CommandeFetcher(), permanent: true);
          Get.put(ResidenceDetailController(), permanent: true);
          Get.put(RoleController(), permanent: true);
        }),
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF6F1F1),
            textTheme: GoogleFonts.poppinsTextTheme()),
      ),
    );
  }
}
