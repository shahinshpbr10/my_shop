import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_shop/common/widgets/build_onboarding_page.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/auth/loginpage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: TColors.dark,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 2);
            },
            children: [
              buildPage(
                  imageUrl: "assets/svg/onboarding1.svg",
                  title: "Main Text",
                  subtitle:
                      "Lorem ipsum dolor sit amet consectetur. Dictumst consectetur aenean nisi semper in dolor nulla. Volutpat velit enim neque id condimentum turpis. Vel donec ipsum odio malesuada sit turpis. Tellus cursus donec risus et facilisi mollis sagittis turpis."),
              buildPage(
                  imageUrl: "assets/svg/onboarding2.svg",
                  title: "Main Text",
                  subtitle:
                      "Lorem ipsum dolor sit amet consectetur. Dictumst consectetur aenean nisi semper in dolor nulla. Volutpat velit enim neque id condimentum turpis. Vel donec ipsum odio malesuada sit turpis. Tellus cursus donec risus et facilisi mollis sagittis turpis."),
              buildPage(
                  imageUrl: "assets/svg/onboarding3.svg",
                  title: "Main Text",
                  subtitle:
                      "Lorem ipsum dolor sit amet consectetur. Dictumst consectetur aenean nisi semper in dolor nulla. Volutpat velit enim neque id condimentum turpis. Vel donec ipsum odio malesuada sit turpis. Tellus cursus donec risus et facilisi mollis sagittis turpis.")
            ],
          ),
        ),
        bottomSheet: isLastPage
            ? Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Container(
                  color: TColors.dark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200.0, // Set the desired width
                        height: 50.0, // Set the desired height
                        alignment: Alignment.center,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: TColors.buttonPrimary,
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Set the border radius
                              )),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          },
                          child: Text(
                            'Get Started',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                color: TColors.dark,
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        }));
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 186, 183, 183),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          dotColor: TColors.grey,
                          activeDotColor: TColors.primary,
                        ),
                        count: 3,
                        onDotClicked: (index) => controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        // Set splashColor and highlightColor to transparent
                        shadowColor: TColors.grey,
                      ),
                      onPressed: () => controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        width: 65,
                        height: 45,
                        decoration: BoxDecoration(
                            color: TColors.buttonPrimary,
                            borderRadius: BorderRadius.circular(15)),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          size: 35,
                          color: TColors.primaryBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
