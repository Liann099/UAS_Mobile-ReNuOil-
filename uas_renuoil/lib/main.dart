import 'package:flutter/material.dart';
import 'package:flutter_application_1/legal/privacy_policy.dart';
import 'package:flutter_application_1/legal/terms_of_service.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/settings/accessibility.dart';
import 'package:flutter_application_1/settings/create_profile.dart';
import 'package:flutter_application_1/settings/history.dart';
import 'package:flutter_application_1/settings/login_security.dart';
import 'package:flutter_application_1/settings/notification.dart';
import 'package:flutter_application_1/settings/payment_payouts.dart';
import 'package:flutter_application_1/settings/personal_info.dart';
import 'package:flutter_application_1/settings/privacy_sharing.dart';
import 'package:flutter_application_1/settings/profile.dart';
import 'package:flutter_application_1/settings/translation.dart';
import 'package:flutter_application_1/signup.dart';
import 'package:flutter_application_1/support/feedback_form.dart';
import 'package:flutter_application_1/support/help_center.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/help-center',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUpScreen(),
        '/profile': (context) => ProfilePage(),
        '/personal-info': (context) => PersonalInfoScreen(),
        '/login-security': (context) => LoginSecurityScreen(),
        '/privacy-sharing': (context) => PrivacySharingScreen(),
        '/translation': (context) => TranslationScreen(),
        '/payment-payouts': (context) => PaymentsPayoutsScreen(),
        '/accessibility': (context) => AccessibilityScreen(),
        '/history': (context) => HistoryScreen(),
        '/notification': (context) => NotificationsScreen(),
        '/feedback-form': (context) => FeedbackScreen(),
        '/terms-of-service': (context) => TermsOfServiceScreen(),
        '/privacy-policy': (context) => PrivacyPolicyScreen(),
        '/create-profile': (context) => CreateProfileScreen(),
        '/help-center': (context) => HelpCenterScreen(),

      },
    );
  }
}
