import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/views/CustomerHome/managers/cart_manager.dart';

import 'package:my_shop/views/ShopHomePage/view/add_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> productData;
  final Set<String> availableSizes;

  const ProductDetailScreen({
    super.key,
    required this.productData,
    required this.availableSizes,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Set<String> _selectedSizes = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final productName = widget.productData['name'] as String? ?? 'No Name';
    final productPrice = widget.productData['price'].toString();
    final productImageUrl = widget.productData['imageUrl'] as String? ??
        'https://via.placeholder.com/150';

    return Scaffold(
      appBar: AppBar(
        title: Text(productName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              productImageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Price: \$$productPrice',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Select Size:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            SizeSelectionField(
              availableSizes: widget.availableSizes,
              initialSizes: _selectedSizes,
              onChanged: (values) {
                setState(() {
                  _selectedSizes = values;
                });
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedSizes.isNotEmpty
                  ? () {
                      _addToCart();
                    }
                  : null,
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final String userId = user.uid;

      // Get a reference to the "cart" collection
      final CollectionReference cartCollection = _firestore.collection('cart');

      // Create a document for the product in the "cart" collection
      await cartCollection.doc().set({
        'userId': userId, // Add the user's ID to the document
        'name': widget.productData['name'],
        'price': widget.productData['price'],
        'imageUrl': widget.productData['imageUrl'],
        'sizes': _selectedSizes.toList(),
        // Add any other relevant product data
      });

      _showSuccessMessage(widget.productData['name'] as String);
    } else {
      // Handle the case when the user is not signed in
      print('User not signed in');
    }
  }

  void _showSuccessMessage(String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text('$productName added to cart!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
