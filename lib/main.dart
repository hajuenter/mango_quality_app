import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/colors.dart';
import 'controllers/auth_controller.dart';
import 'controllers/nav_controller.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerAndroid: AndroidDebugProvider(
      debugToken: dotenv.env['FIREBASE_DEBUG_TOKEN'],
    ),
  );

  await initializeDateFormatting('id_ID', null);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryAuth,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  // Initialize Controllers
  Get.put(AuthController());
  Get.put(NavController());
  Gemini.init(apiKey: apiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mango App',
      initialRoute: AppRoutes.splash,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 350),
      getPages: AppRoutes.routes,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryAuth),
      ),
    );
  }
}
