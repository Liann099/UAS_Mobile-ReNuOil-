import 'package:flutter/material.dart';
import 'package:flutter_application_1/legal/privacy_policy.dart';
import 'package:flutter_application_1/legal/terms_of_service.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/settings/accessibility.dart';
import 'package:flutter_application_1/settings/history.dart';
import 'package:flutter_application_1/settings/login_security.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:flutter_application_1/support/feedback_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/terms-of-service',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUpScreen(),
        '/login-security': (context) => LoginSecurityScreen(),
        '/accessibility': (context) => AccessibilityScreen(),
        '/history': (context) => HistoryScreen(),
        '/feedback-form': (context) => FeedbackScreen(),
        '/terms-of-service': (context) => TermsOfServiceScreen(),
        '/privacy-policy': (context) => PrivacyPolicyScreen(),
      },
    );
  }
}
