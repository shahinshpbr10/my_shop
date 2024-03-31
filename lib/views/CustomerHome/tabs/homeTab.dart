import 'package:flutter/material.dart';
import 'package:my_shop/common/widgets/widgets/find_shops.dart';
import 'package:my_shop/common/widgets/widgets/header.dart';
import 'package:my_shop/constants/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: TColors.dark,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  const TopCardSection(),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Text(
                        "Available shops",
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 500, child: ShopsNearCustomer()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
