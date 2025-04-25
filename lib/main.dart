import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:osborn_book/connectivity/internet_controller.dart';
import 'package:osborn_book/home/home_page.dart';
import 'package:osborn_book/onboarding/onboarding_page.dart';
import 'package:osborn_book/pdf/app_state.dart';
import 'package:osborn_book/pdf/pdf_viewer_screen.dart';
import 'package:osborn_book/publication_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await _checkAuthStatus();
  String? deviceToken = await getDeviceToken();
  Get.put(InternetController(),permanent: true);
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppState()),
        ],
        child: MyApp(isLoggedIn: isLoggedIn,),
      ),
  );

}

Future<bool> _checkAuthStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_logged_in') ?? false;
}

Future<String?> getDeviceToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getString('device_token'));
  return prefs.getString('device_token');
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isLoggedIn?HomePage(deviceToken: getDeviceToken().toString()): const OnboardingPage(),
      // home:  PublicationsScreen(),
      // home: PdfViewerPage(),

    );
  }
}

