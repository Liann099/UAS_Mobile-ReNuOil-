import 'package:flutter/material.dart';
import 'package:flutter_application_1/maps/location_map.dart';
import 'package:flutter_application_1/controller/google_login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
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
import 'package:flutter_application_1/balance.dart';

// Settings
import 'package:flutter_application_1/settings/accessibility.dart';
import 'package:flutter_application_1/settings/add_payout_method.dart';
import 'package:flutter_application_1/settings/create_profile.dart';
import 'package:flutter_application_1/settings/credits_and_coupons.dart';
import 'package:flutter_application_1/settings/delete_account.dart';
import 'package:flutter_application_1/settings/earnings.dart';
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
import 'package:flutter_application_1/Homepage/Buyer/balancebuy.dart';

// Seller Homepage
import 'package:flutter_application_1/Seller/seller.dart';
import 'package:flutter_application_1/Seller/pickup.dart';
import 'package:flutter_application_1/Seller/sellerwithdraw.dart';
import 'package:flutter_application_1/Seller/QRseller.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<GoogleSignInCubit>(
          create: (context) => GoogleSignInCubit(),
        ),
        // Add other cubits here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      // home: const AuthChecker(),
      home:  LoginScreen(), // Changed from SellerPage to AuthChecker
      routes: {
        '/home': (context) => HomePage(),
        '/balanceseller': (context) => RnoPayApp(),

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
        '/credits-and-coupons': (context) => CreditsAndCouponsScreen(),
        '/add-payout-method': (context) => AddPayoutMethodScreen(),
        '/payout-setup': (context) => PayoutSetupScreen(),
        '/earnings': (context) => EarningsScreen(),

        '/location-map': (context) => const LocationMapScreen(),

        //Buyer
        '/buyer-default': (context) => const BuyerHomePage(),
        '/buyer-balance': (context) => const RnoPayApps(),

        //Seller
        '/seller': (context) => const SellerPage(),
        '/pickup': (context) => const PickupPage(),
        '/seller-withdraw': (context) => const SellerWithdrawPage(),
        '/qr-seller': (context) => const QRSellerPage(),
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

      '/location-map': 'Live Location Map',

      // Shortcut to test your Buyer homepage
      '/buyer-home': 'Buyer Homepage',
      '/buyer-default': 'Buyer Default',

      // seller homepage
      '/seller': 'Seller Homepage',
      '/pickup': 'Pickup Page',
      '/seller-withdraw': 'Seller Withdraw',
      '/qr-seller': 'QR Seller',
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


class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  final storage = FlutterSecureStorage(); // <-- ini WAJIB
  bool? _isLoggedIn; // null artinya masih loading

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      String? token = await storage.read(
          key: 'access_token'); // Ensure you are checking the correct token
      if (token != null) {
        print("Access Token: $token"); // Print the access token if it exists
      }
      setState(() {
        _isLoggedIn =
            token != null; // Update login status based on token presence
      });
    } catch (e) {
      // Handle error (e.g., log it, show a message)
      print("Error reading auth token: $e");
      setState(() {
        _isLoggedIn = false; // Default to not logged in on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      // Masih loading, kasih loading screen dulu
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else if (_isLoggedIn == true) {
      return LoginScreen();

      // return const SellerPage();
    } else {
      return LoginScreen();
    }
  }
}
