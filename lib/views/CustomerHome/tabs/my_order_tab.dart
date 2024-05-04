import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:my_shop/common/widgets/widgets/pageheading.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/CustomerHome/pages/order_details_page.dart';

class MyOrdersCustomerPage extends StatefulWidget {
  const MyOrdersCustomerPage({super.key});

  @override
  _MyOrdersCustomerPageState createState() => _MyOrdersCustomerPageState();
}

class _MyOrdersCustomerPageState extends State<MyOrdersCustomerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              child: StreamBuilder<QuerySnapshot>(
                stream: _getOrdersStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final orders = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final orderData = order.data() as Map<String, dynamic>?;

                      if (orderData == null) {
                        return const SizedBox.shrink();
                      }

                      return buildOrderItem(orderData);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getOrdersStream() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String userId = user.uid;
      return _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Widget buildOrderItem(Map<String, dynamic> orderData) {
    final items = orderData['items'] as List<dynamic>? ?? [];
    return Card(
      elevation: 0,
      color: TColors.darkContainer,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: items.isNotEmpty
            ? Image.network(
                items.first['imageUrl'],
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              )
            : const SizedBox.shrink(),
        title: items.isNotEmpty
            ? Text(items.first['name']) // Use the name of the first item
            : const Text('No items'), // Or any other appropriate text
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Address: ${orderData['address']}'),
            Text('Payment Method: ${orderData['paymentMethod']}'),
            Text('Total Items: ${items.length}'),
            Text(
              'Total: ${items.map((item) => item['price'])}',
            ), // Calculate the total from item prices
          ],
        ),
        onTap: () {
          navigateToOrderDetails(context, orderData);
        },
      ),
    );
  }

  void navigateToOrderDetails(
    BuildContext context,
    Map<String, dynamic> orderData,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(orderData: orderData),
      ),
    );
  }
}
