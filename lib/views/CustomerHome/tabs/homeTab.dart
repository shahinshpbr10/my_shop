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
    return const SafeArea(
      child: Scaffold(
        backgroundColor: TColors.dark,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      TopCardSection(),
                      SizedBox(height: 16),
                      FindShopkeeper(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
