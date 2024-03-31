import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

import 'package:my_shop/views/CustomerHome/pages/shop_detail_page.dart'; // Import the shop details screen

class ShopsNearCustomer extends StatefulWidget {
  const ShopsNearCustomer({super.key});

  @override
  State<ShopsNearCustomer> createState() => _ShopsNearCustomerState();
}

class _ShopsNearCustomerState extends State<ShopsNearCustomer> {
  Stream<List<DocumentSnapshot>>? shopsStream;

  @override
  void initState() {
    super.initState();
    _getAllShops();
  }

  Future<void> _getAllShops() async {
    shopsStream = FirebaseFirestore.instance
        .collection('shopkeepers')
        .snapshots()
        .map((event) => event.docs);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return shopsStream != null
        ? StreamBuilder<List<DocumentSnapshot>>(
            stream: shopsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final shops = snapshot.data!;
                return ListView.separated(
                  itemCount: shops.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final shop = shops[index];
                    final data = shop.data() as Map<String, dynamic>;
                    return InkWell(
                      onTap: () {
                        // Navigate to the shop details screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopDetailsScreen(
                              shopData: data,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: TColors.darkerGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Image(
                            image: NetworkImage(
                              data['shopImageUrl'],
                            ),
                          ),
                          title: Text(
                            data['shopName'],
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Owner:'),
                                  Text(data['ownerName']),
                                ],
                              ),
                              Text(data['shoptype']),
                            ],
                          ),
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
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
