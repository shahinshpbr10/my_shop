import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:givestarreviews/givestarreviews.dart';
import 'package:my_shop/Backend/fetchhelpers.dart';
import 'package:my_shop/common/widgets/widgets/managment_card.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/ShopHomePage/view/add_product_screen.dart';
import 'package:my_shop/views/ShopHomePage/view/available_order_page.dart';
import 'package:my_shop/views/ShopHomePage/view/available_stock_page.dart';
import 'package:my_shop/views/auth/loginpage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FetchHelpers fetchHelpers = FetchHelpers();
Future<String?> getShopId() async {
  final user = _auth.currentUser;
  if (user != null) {
    final shopDoc =
        await _firestore.collection('shopkeepers').doc(user.uid).get();
    if (shopDoc.exists) {
      final shopData = shopDoc.data();
      if (shopData != null && shopData.containsKey('shopId')) {
        return shopData['shopId'];
      }
    }
  }
  return null;
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
                      FutureBuilder<String>(
                        future: fetchHelpers.fetchUserProfilePictureUrl(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While waiting for the data, show a placeholder
                            return const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  "assets/images/profile.png"), // Placeholder image
                            );
                          } else if (snapshot.hasError ||
                              snapshot.data!.isEmpty) {
                            // In case of an error or if the URL is empty, show a default avatar
                            return const CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(
                                  "assets/images/profile.png"), // Default image
                            );
                          } else {
                            // When data is fetched successfully, show the profile picture
                            return CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(snapshot
                                  .data!), // Fetched profile picture URL
                              backgroundColor: Colors.transparent,
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good morning....",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          FutureBuilder<String>(
                            future: fetchHelpers
                                .fetchUserName(), // Fetch the user name
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                    "Loading..."); // Optionally handle loading state
                              } else if (snapshot.hasError) {
                                return Text(
                                    "Error: ${snapshot.error}"); // Error handling
                              } else {
                                return Text(
                                  snapshot.data!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall, // Display the fetched name
                                  // Add text style if needed
                                );
                              }
                            },
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
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       InkWell(
  onTap: () async {
    final shopId = await getShopId();
    if (shopId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ShopkeeperOrdersPage(shopId: shopId),
        ),
      );
    } else {
      // Handle the case when shopId is null
      // e.g., show an error message or perform any other action
    }
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
                              return const AddProductScreen();
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
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const AvailableStockPage();
                              },
                            ));
                          },
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
