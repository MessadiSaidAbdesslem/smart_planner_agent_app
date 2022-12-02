import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:smart_planner_agent_app/firebase_options.dart';
import 'package:smart_planner_agent_app/screens/auth/login/login_page.dart';
import 'package:smart_planner_agent_app/screens/auth/reset/reset_password.dart';
import 'package:smart_planner_agent_app/screens/auth/signup/signup_page.dart';
import 'package:smart_planner_agent_app/screens/home/home_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/commandes/controlPage/control_page.dart';
import 'package:smart_planner_agent_app/screens/home/sub_pages/profile/editPersonnelInfo/edit_personnel_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.authStateChanges().first;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? LoginPage.id
            : HomePage.id,
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
              name: ControlPage.id, page: () => SafeArea(child: ControlPage()))
        ],
        initialBinding: BindingsBuilder(() {
          Get.put(AuthController(), permanent: true);
          Get.put(NavigatorController(), permanent: true);
          Get.put(EditPersonnalInfoController(), permanent: true);
          Get.put(AgentsFetcher(), permanent: true);
          Get.put(CommandeFetcher(), permanent: true);
          Get.put(ResidenceDetailController(), permanent: true);
        }),
        theme: ThemeData(
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: const Color(0xFFF6F1F1),
            textTheme: GoogleFonts.poppinsTextTheme()),
      ),
    );
  }
}
