
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    print("Initializing InternetController...");

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((ConnectivityResult cr) {
      print("Connectivity changed: $cr");
      NetStatus(cr);
    });
  }

  void NetStatus(ConnectivityResult cr) {
    print("NetStatus called with: $cr");

    if (cr == ConnectivityResult.none) {
      print("No internet connection detected.");
      Get.rawSnackbar(
        titleText: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height *0.05,
          ),
          width: double.infinity,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No internet Connection ",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ],
          ),
        ),
        messageText: SizedBox(),
        backgroundColor: Colors.black87,
        isDismissible: false,
        duration: Duration(days: 1),
      );
    } else {
      print("Internet connection is available.");
      if (Get.isSnackbarOpen) {
        print("Closing current snackbar.");
        Get.closeCurrentSnackbar();
      }
    }
  }
}
