import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/CustomerHome/managers/cart_manager.dart';
import 'package:my_shop/views/CustomerHome/pages/product_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> shopData;

  const ShopDetailsScreen({super.key, required this.shopData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.black,
      appBar: AppBar(
        title: Text(shopData['shopName']),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                shopData['shopImageUrl'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Owner: ${shopData['ownerName']}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Shop Type: ${shopData['shopType']}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Address: ${shopData['shopAddress']}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8.0),
                  Text(
                    'Phone: ${shopData['contactNumber']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.email),
                  const SizedBox(width: 8.0),
                  Text(
                    'Email: ${shopData['email']}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        _launchURL(shopData['websiteUrl'], context),
                    child: const Text('Visit Website'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () =>
                        _makePhoneCall(shopData['contactNumber'], context),
                    child: const Text('Call'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                "Available Products from Shop",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              _buildProductList(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not place call to $phoneNumber'),
        ),
      );
    }
  }

  Widget _buildProductList(BuildContext context) {
    final String? shopId = shopData['shopId'];
    if (shopId == null) {
      print('Shop ID is null.');
      return const Text('Shop ID is not available.');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('shopId', isEqualTo: shopId)
          .orderBy('name') // Make sure the index for this query is created.
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('Snapshot error: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          print('No products found for shopId: $shopId');
          return const Text('No products available for this shop.');
        }

        print('${docs.length} products found for shopId: $shopId');
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var productData = docs[index].data() as Map<String, dynamic>;
            var productImageUrl = productData['imageUrl'] as String? ??
                'https://via.placeholder.com/150'; // Provide a placeholder image URL
            var productName = productData['name'] as String? ?? 'No Name';
            var productPrice = productData['price'].toString();

            return GestureDetector(
              onTap: () {
                var availableSizes =
                    Set<String>.from(productData['sizes'] ?? []);
                // Navigate to the product detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      productData: productData,
                      availableSizes: availableSizes,
                     
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        productImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$$productPrice',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
