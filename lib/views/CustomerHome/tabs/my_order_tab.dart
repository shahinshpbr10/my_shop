import 'package:flutter/material.dart';
import 'package:my_shop/common/widgets/widgets/pageheading.dart';
import 'package:my_shop/constants/color.dart';

class MyOrdersCustomerPage extends StatefulWidget {
  const MyOrdersCustomerPage({super.key});

  @override
  _MyOrdersCustomerPageState createState() => _MyOrdersCustomerPageState();
}

class _MyOrdersCustomerPageState extends State<MyOrdersCustomerPage> {
  final List<Map<String, dynamic>> orders = [
    {
      'id': 1,
      'product': 'Product X',
      'quantity': 2,
      'total': 60.0,
      'imageUrl': 'assets/images/profile.png',
    },
    {
      'id': 2,
      'product': 'Product Y',
      'quantity': 1,
      'total': 40.0,
      'imageUrl': 'assets/images/profile.png',
    },
    {
      'id': 3,
      'product': 'Product Z',
      'quantity': 3,
      'total': 90.0,
      'imageUrl': 'assets/images/profile.png',
    },
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.dark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: TColors.dark,
            child: const PageHeading(headingText: "My Orders"),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return buildOrderItem(order);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderItem(Map<String, dynamic> order) {
    return Card(
      elevation: 0,
      color: TColors.darkContainer,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Image.asset(
          order['imageUrl'],
          height: 50, // Adjust the height as needed
          width: 50, // Adjust the width as needed
          fit: BoxFit.cover,
        ),
        title: Text('Order ${order['id']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${order['product']}'),
            Text('Quantity: ${order['quantity']}'),
            Text('Total: \$${order['total']}'),
          ],
        ),
        onTap: () {
          navigateToOrderDetails(context, order);
        },
      ),
    );
  }

  void navigateToOrderDetails(
      BuildContext context, Map<String, dynamic> order) {
    // Add navigation logic to the order details page for customers
    // For now, let's print the order details to the console
    print('Order Details: $order');
  }
}
