import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

class ShopkeeperOrdersPage extends StatefulWidget {
  final String shopId;

  const ShopkeeperOrdersPage({Key? key, required this.shopId})
      : super(key: key);

  @override
  State<ShopkeeperOrdersPage> createState() => _ShopkeeperOrdersPageState();
}

class _ShopkeeperOrdersPageState extends State<ShopkeeperOrdersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        backgroundColor: TColors.dark,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('orders')
            .where('shopId', isEqualTo: widget.shopId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final orders = snapshot.data!.docs;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index].data() as Map<String, dynamic>;
                return Card(
                  color: TColors.darkerGrey,
                  child: ListTile(
                    title: Text('Order #${order['orderId']}'),
                    subtitle: Text('Total: \$${order['totalAmount']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        // Navigate to order details page
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
