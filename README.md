# osborn_book

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


lib/
│
├── main.dart                     # Entry point of the application
│
├── core/                         # Core utilities and services
│   ├── constants/                # Application-wide constants
│   ├── services/                 # External services (e.g., API services)
│   │   ├── api_service.dart       # API service class for network requests
│   │   ├── auth_service.dart      # Authentication-related functions
│   └── utils/                    # Utility functions (e.g., device info)
│       └── device_info.dart      # Device ID retrieval
│
├── models/                       # Data models
│   ├── auth_response.dart         # Model for authentication response
│   └── publication.dart           # Model for publication data
│
├── screens/                      # UI screens
│   ├── login/                    # Login-related files
│   │   ├── login_page.dart        # Login page UI
│   │   └── login_controller.dart   # Controller for managing login state
│   │
│   ├── home/                     # Home-related files
│   │   ├── home_page.dart         # Home page UI
│   │   └── home_controller.dart    # Controller for managing home state
│   │
│   ├── publications/              # Publications-related files
│   │   ├── publications_page.dart  # Publications listing UI
│   │   └── publications_controller.dart # Controller for managing publications state
│   │
│   └── error_page.dart            # Error page UI for handling errors globally
│
├── widgets/                      # Reusable UI components
│   ├── custom_button.dart          # Custom button widget
│   └── loading_indicator.dart       # Loading indicator widget
│
├── bindings/                     # Dependency injection using GetX
│   ├── login_binding.dart          # Bindings for login-related dependencies
│   ├── home_binding.dart           # Bindings for home-related dependencies
│   └── publications_binding.dart    # Bindings for publications-related dependencies
│
└── theme/                        # Theme and styling
├── app_theme.dart             # Application-wide theme settings
└── colors.dart                # Color constants


import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
@override
void dependencies() {
Get.lazyPut<LoginController>(() => LoginController());
}
}

import 'package:get/get.dart';
import 'bindings/login_binding.dart';
import 'screens/login/login_page.dart';

class AppRoutes {
static const String login = '/login';

static List<GetPage> routes = [
GetPage(
name: login,
page: () => const LoginPage(),
binding: LoginBinding(),
),
// Add other routes here
];
}

// screens/login/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
final LoginController loginController = Get.put(LoginController());
final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text('Login')),
body: Center(
child: Padding(
padding: const EdgeInsets.all(16.0),
child: Obx(() {
return Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
TextField(
controller: emailController,
decoration: InputDecoration(labelText: 'Email'),
),
SizedBox(height: 16),
TextField(
controller: passwordController,
obscureText: true,
decoration: InputDecoration(labelText: 'Password'),
),
SizedBox(height: 16),
if (loginController.isLoading.value)
CircularProgressIndicator()
else
ElevatedButton(
onPressed: () {
loginController.login(
emailController.text,
passwordController.text,
);
},
child: Text('Login'),
),
SizedBox(height: 16),
if (loginController.errorMessage.isNotEmpty)
Text(
loginController.errorMessage.value,
style: TextStyle(color: Colors.red),
),
],
);
}),
),
),
);
}
}
