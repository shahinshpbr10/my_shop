import 'package:flutter/material.dart';

import 'package:my_shop/theme/theme.dart';
import 'package:my_shop/views/OnBoardingPage/onboarding_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const OnboardingPage(),
    );
  }
}
