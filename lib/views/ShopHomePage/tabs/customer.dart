import 'package:flutter/material.dart';
import 'package:my_shop/common/widgets/widgets/pageheading.dart';
import 'package:my_shop/common/widgets/widgets/text_form_feild_with_label.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/data/customerdata.dart';

class CustomerTab extends StatefulWidget {
  const CustomerTab({super.key});

  @override
  State<CustomerTab> createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: TColors.dark,
        body: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            const PageHeading(
              headingText: "Find Customers",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormFieldWithLabel(
                controller: searchController,
                hintText: "Search here",
                labelText: "",
                iconData: Icons.search,
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(customers[index].image),
                      ),
                      title: Text(customers[index].name),
                      subtitle: Text(customers[index].subtitle),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(customers[index].time),
                          const SizedBox(height: 5),
                          Text(" ${customers[index].messageCount}"),
                        ],
                      ),
                      onTap: () {
                        // Handle item tap
                        print('Tapped on: ${customers[index].name}');
                      },
                    ),
                    const Divider(
                      height: 1,
                      color: TColors.buttonPrimary,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
