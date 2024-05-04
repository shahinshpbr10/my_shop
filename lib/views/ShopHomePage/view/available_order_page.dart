import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/ShopHomePage/view/order_detail_page.dart';

class ShopkeeperOrdersPage extends StatefulWidget {
  final String shopId;

  const ShopkeeperOrdersPage({required this.shopId, super.key});

  @override
  _ShopkeeperOrdersPageState createState() => _ShopkeeperOrdersPageState();
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
                final items = order['items'] as List<dynamic>;
                return Card(
                  color: TColors.darkerGrey,
                  child: ExpansionTile(
                    title: Text('View Your Orders'),
                    children: items
                        .map(
                          (item) => InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (ctx) {
                                return OrderDetailsPage(
                                  orderData: order,
                                );
                              }));
                            },
                            child: ListTile(
                              title: Text(item['name']),
                              subtitle: Text('\$${item['price']}'),
                              trailing: Image.network(
                                item['imageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
