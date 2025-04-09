import 'package:flutter/material.dart';

// Auth
import 'package:flutter_application_1/auth/address_input.dart';
import 'package:flutter_application_1/auth/buyer_or_seller.dart';
import 'package:flutter_application_1/auth/create_new_password.dart';
import 'package:flutter_application_1/auth/forgot_password.dart';
import 'package:flutter_application_1/auth/how_did_you_know.dart';
import 'package:flutter_application_1/auth/make_passcode.dart';
import 'package:flutter_application_1/auth/seller_inquiry.dart';
import 'package:flutter_application_1/auth/verify_email.dart';
import 'package:flutter_application_1/auth/signup.dart';

// Legal
import 'package:flutter_application_1/legal/privacy_policy.dart';
import 'package:flutter_application_1/legal/terms_of_service.dart';

// Screens
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/home.dart';

// Settings
import 'package:flutter_application_1/settings/accessibility.dart';
import 'package:flutter_application_1/settings/add_payout_method.dart';
import 'package:flutter_application_1/settings/create_profile.dart';
import 'package:flutter_application_1/settings/delete_account.dart';
import 'package:flutter_application_1/settings/edit_profile.dart';
import 'package:flutter_application_1/settings/history.dart';
import 'package:flutter_application_1/settings/login_security.dart';
import 'package:flutter_application_1/settings/notification.dart';
import 'package:flutter_application_1/settings/payment_methods.dart';
import 'package:flutter_application_1/settings/payment_payouts.dart';
import 'package:flutter_application_1/settings/payout_setup.dart';
import 'package:flutter_application_1/settings/personal_info.dart';
import 'package:flutter_application_1/settings/privacy_sharing.dart';
import 'package:flutter_application_1/settings/profile.dart';
import 'package:flutter_application_1/settings/translation.dart';

// Support
import 'package:flutter_application_1/support/feedback_form.dart';
import 'package:flutter_application_1/support/help_center.dart';

// Buyer homepage screen
import 'package:flutter_application_1/Homepage/Buyer/default.dart';

// Seller Homepage
import 'package:flutter_application_1/Seller/seller.dart';
import 'package:flutter_application_1/Seller/pickup.dart';
import 'package:flutter_application_1/Seller/sellerwithdraw.dart';



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
      home: const RouteButtonsScreen(),
      routes: {
        '/buttons': (context) => const RouteButtonsScreen(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
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
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/verify-email': (context) =>
            VerifyEmailScreen(email: 'email@example.com'),
        '/create-new-password': (context) => CreateNewPasswordScreen(),
        '/address-input': (context) => AddressInputScreen(),
        '/buyer-or-seller': (context) => BuyerOrSellerScreen(),
        '/how-did-you-know': (context) => HowDidYouKnowScreen(),
        '/make-passcode': (context) => MakePasscodeScreen(),
        '/seller-inquiry': (context) => SellerInquiryScreen(),
        '/add-payout-method': (context) => AddPayoutMethodScreen(),
        '/payout-setup': (context) => PayoutSetupScreen(),

        // Buyer HomePage route added here:
        '/buyer-home': (context) => const BuyerHomePage(),

        // seller homepage
        '/seller': (context) => const SellerPage(),
        '/pickup': (context) => const PickupPage(),
        '/seller-withdraw': (context) => const SellerWithdrawPage(), 
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
      '/forgot-password': 'Forgot Password',
      '/verify-email': 'Verify Email',
      '/create-new-password': 'Create New Password',
      '/address-input': 'Address Input',
      '/buyer-or-seller': 'Buyer or Seller',
      '/how-did-you-know': 'How Did You Know',
      '/make-passcode': 'Make Passcode',
      '/seller-inquiry': 'Seller Inquiry',
      '/add-payout-method': 'Add Payout Method',
      '/payout-setup': 'Payout Setup',

      // Shortcut to test your Buyer homepage
      '/buyer-home': 'Buyer Homepage',

      // seller homepage
      '/seller': 'Seller Homepage',
      '/pickup': 'Pickup Page',
      '/seller-withdraw': 'Seller Withdraw',

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
