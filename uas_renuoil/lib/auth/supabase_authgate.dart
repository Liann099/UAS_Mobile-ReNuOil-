/*

AUTH GATE - This will continously listen for auth state changes.

-----------------------------------------------------------------
unauthenticated -> login page
authenticated -> profile page

*/
import 'package:flutter/material.dart';
import 'package:flutter_application_1/settings/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      //build appropriate page based in auth state
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        //check if theres a valid session currently

        final session = snapshot.hasData ? snapshot.data!.session : null;
        if (session != null) {
          return ProfilePage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
