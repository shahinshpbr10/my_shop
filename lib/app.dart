import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_shop/theme/theme.dart';
import 'package:my_shop/views/CustomerHome/customerhome.dart';
import 'package:my_shop/views/OnBoardingPage/onboarding_page.dart';
import 'package:my_shop/views/ShopHomePage/home.dart';
import 'package:my_shop/views/auth/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final prefs = snapshot.data as SharedPreferences;
            final bool seenOnBoarding =
                prefs.getBool('seenOnBoarding') ?? false;

            // Check if user is logged in
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && seenOnBoarding) {
              // User is logged in, check role
              return FutureBuilder<String>(
                future: getUserRole(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final String role = snapshot.data!;
                    if (role == 'customer') {
                      return const CustomerHome();
                    } else if (role == 'shopkeeper') {
                      return const ShopkeeperHome();
                    }
                  }
                  return const CircularProgressIndicator(); // Show loading while fetching user data
                },
              );
            } else if (!seenOnBoarding) {
              // User hasn't seen onboarding
              return OnboardingPage(prefs: prefs);
            } else {
              // User is not logged in
              return const LoginScreen();
            }
          },
        ));
  }
}

// Function to get user role
Future<String> getUserRole(String userId) async {
  final customerDoc = await FirebaseFirestore.instance
      .collection('Customerusers')
      .doc(userId)
      .get();
  if (customerDoc.exists) {
    return 'customer';
  }
  final shopkeeperDoc = await FirebaseFirestore.instance
      .collection('shopkeepers')
      .doc(userId)
      .get();
  if (shopkeeperDoc.exists) {
    return 'shopkeeper';
  }
  return 'unknown'; // Consider how to handle users not found in either collection
}
