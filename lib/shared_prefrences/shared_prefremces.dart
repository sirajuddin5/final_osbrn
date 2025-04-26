import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentication/login_page.dart';

Future<void> logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token'); // Remove the auth token
  await prefs.setBool('is_logged_in', false); // Set login status to false

  await HiveService.deleteDeviceToken();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
        builder: (context) => const LoginPage()), // Navigate to LoginPage
  );
}
