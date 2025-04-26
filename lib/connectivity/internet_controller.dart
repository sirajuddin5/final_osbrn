
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
      
      // Check if we're already on the downloaded PDFs page to avoid navigation loops
      final String? currentRoute = Get.currentRoute;
      if (currentRoute != null && !currentRoute.contains('/downloaded_pdfs')) {
        // Navigate to downloaded PDFs page if not already there
        print("Navigating to downloaded PDFs page due to no internet.");
        Get.toNamed('/downloaded_pdfs');
        
        // Show a temporary message explaining the navigation
        Get.snackbar(
          'No Internet Connection',
          'Redirecting to your downloaded PDFs',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
      
    } else {
      print("Internet connection is available.");
      if (Get.isSnackbarOpen) {
        print("Closing current snackbar.");
        Get.closeCurrentSnackbar();
      }
    }
  }
}
