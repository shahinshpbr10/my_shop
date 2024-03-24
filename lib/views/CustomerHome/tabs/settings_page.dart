import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:my_shop/common/widgets/widgets/settings_tiles.dart';
import 'package:my_shop/common/widgets/widgets/user_tile_settings.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/auth/loginpage.dart';

class CustomerSettingsTab extends StatefulWidget {
  const CustomerSettingsTab({super.key});

  @override
  State<CustomerSettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<CustomerSettingsTab> {
  bool isPushNotification = false;
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login screen or any other desired screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background container
            Container(
              height: 290,
              decoration: const BoxDecoration(
                color: TColors.buttonPrimary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 41,
                      vertical: 40,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.settings, size: 30, color: TColors.white),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Settings",
                            style: Theme.of(context).textTheme.headlineLarge),
                        const Spacer(),
                        IconButton(
                            onPressed: () => logout(context),
                            icon: const Icon(
                              Iconsax.logout,
                              size: 30,
                              color: TColors.white,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: double.infinity,
            ),
            // Stacked Container
            Positioned(
              top: 120,
              left: 20,
              right: 20,
              child: Container(
                height: screenHeight * 1.9, // Adjust the fraction as needed
                decoration: BoxDecoration(
                  color: TColors.dark,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Your content for the stacked container
                    const SizedBox(
                      height: 20,
                    ),
                    const UserTileSettings(),
                    const Divider(
                      thickness: 3,
                      color: TColors.buttonPrimary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Account Settings",
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    const SettingsTiles(
                      labelText: "My Account",
                      iconData: Icons.chevron_right_rounded,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SettingsTiles(
                      labelText: "Add bank ac",
                      iconData: Icons.chevron_right_rounded,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SettingsTiles(
                      labelText: "Edit Delivery address",
                      iconData: Icons.chevron_right_rounded,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SwitchListTile(
                      activeColor: TColors.primary,
                      title: Text(
                        "Push Notifications",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      value: isPushNotification,
                      onChanged: (value) {
                        setState(() {
                          isPushNotification = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SettingsTiles(
                      labelText: "Reviwes & feedback",
                      iconData: Icons.chevron_right_rounded,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      thickness: 3,
                      color: TColors.primary,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("More",
                          style: Theme.of(context).textTheme.headlineLarge),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SettingsTiles(
                      labelText: "About us",
                      iconData: Icons.chevron_right_rounded,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SettingsTiles(
                      labelText: "Privacy policy",
                      iconData: Icons.chevron_right_rounded,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SettingsTiles(
                      labelText: "Terms and conditions",
                      iconData: Icons.chevron_right_rounded,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
