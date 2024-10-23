

import 'dart:async';

import 'package:flutter/material.dart';

import '../authentication/login_page.dart';
import '../colors/colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AColors.onboarding_bg,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("images/onboarding.png"),
            Image.asset("images/osbornlogorgb.png")
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
          () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage())),
    );
  }
}
