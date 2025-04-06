import 'package:flutter/material.dart';
import 'package:flutter_application_1/legal/privacy_policy.dart';
import 'package:flutter_application_1/legal/terms_of_service.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/settings/accessibility.dart';
import 'package:flutter_application_1/settings/create_profile.dart';
import 'package:flutter_application_1/settings/delete_account.dart';
import 'package:flutter_application_1/settings/edit_profile.dart';
import 'package:flutter_application_1/settings/history.dart';
import 'package:flutter_application_1/settings/login_security.dart';
import 'package:flutter_application_1/settings/notification.dart';
import 'package:flutter_application_1/settings/payment_methods.dart';
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
      home: const RouteButtonsScreen(), // Start directly here
      routes: {
        '/buttons': (context) => const RouteButtonsScreen(),
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
        '/edit-profile': (context) => EditProfileScreen(),
        '/delete-account': (context) => DeleteAccountPage(),
        '/payment-methods': (context) => PaymentMethodsScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}

class RouteButtonsScreen extends StatelessWidget {
  const RouteButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = {
      '/login': 'Login',
      '/signup': 'Signup',
      '/home': 'Home',
      '/profile': 'Profile',
      '/personal-info': 'Personal Info',
      '/login-security': 'Login Security',
      '/privacy-sharing': 'Privacy & Sharing',
      '/translation': 'Translation',
      '/payment-payouts': 'Payment & Payouts',
      '/accessibility': 'Accessibility',
      '/history': 'History',
      '/notification': 'Notification',
      '/feedback-form': 'Feedback Form',
      '/terms-of-service': 'Terms of Service',
      '/privacy-policy': 'Privacy Policy',
      '/create-profile': 'Create Profile',
      '/help-center': 'Help Center',
      '/edit-profile': 'Edit Profile',
      '/delete-account': 'Delete Account',
      '/payment-methods': 'Payment Methods',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Test'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: routes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final entry = routes.entries.elementAt(index);
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () => Navigator.pushNamed(context, entry.key),
            child: Text(
              entry.value,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
