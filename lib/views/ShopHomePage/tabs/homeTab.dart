import 'package:flutter/material.dart';
import 'package:givestarreviews/givestarreviews.dart';
import 'package:my_shop/common/widgets/widgets/managment_card.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/auth/loginpage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: TColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  padding: const EdgeInsets.all(10),
                  height: 80,
                  width: double.infinity,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            AssetImage("assets/images/profile.png"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good morning",
                          ),
                          Text(
                            "John Doe", // Replace with the actual username
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications), // Bell icon
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: TColors.primary,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircularPercentIndicator(
                      radius: 60,
                      lineWidth: 15.0,
                      center: const Text(
                        "60%",
                      ),
                      progressColor: TColors.dark,
                      percent: 0.6,
                      animation: true,
                      animationDuration: 1200,
                      circularStrokeCap: CircularStrokeCap.round,
                      header: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Text(
                          "Today's Sale",
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, right: 20, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              const Text(
                                "Total Reviews",
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              StarRating(
                                size: 20,
                              ),
                              const Text(
                                "512",
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "view all",
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_right))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Management Hub",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          },
                          child: const ManagmentCard(
                            imageurl: "assets/icons/order-delivery.png",
                            labeltext: "Orders",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          },
                          child: const ManagmentCard(
                              imageurl: 'assets/icons/pay.png',
                              labeltext: "Payments"),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const LoginScreen();
                            }));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // Set your desired color
                                ),
                                child: Center(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      color: TColors.buttonPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/icons/add.png',
                                        width: 40,
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "Add products",
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const ManagmentCard(
                              imageurl: "assets/icons/incoming-money.png",
                              labeltext: "view bills"),
                        ),
                        InkWell(
                          onTap: () {},
                          child: const ManagmentCard(
                              imageurl: "assets/icons/in-stock.png",
                              labeltext: "Stocks"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
