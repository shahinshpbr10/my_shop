import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AvailableStockPage extends StatefulWidget {
  const AvailableStockPage({super.key});

  @override
  State<AvailableStockPage> createState() => _AvailableStockPageState();
}

class _AvailableStockPageState extends State<AvailableStockPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final shopId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Stock'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: shopId != null
                  ? FirebaseFirestore.instance
                      .collection('products')
                      .where('shopId', isEqualTo: shopId)
                      .where('name', isGreaterThanOrEqualTo: _searchQuery)
                      .where('name', isLessThan: '${_searchQuery}z')
                      .snapshots()
                  : null,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final products = snapshot.data!.docs;
                  if (products.isNotEmpty) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          name: product['name'],
                          price: product['price'],
                          description: product['description'],
                          imageUrl: product['imageUrl'],
                          quantity: product['quantity'],
                          documentId: product.id,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No stock found',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Add stock to inventory',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
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
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final int quantity;
  final String documentId; // Add this line

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.quantity,
    required this.documentId, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 100,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('Price: \$${price.toStringAsFixed(2)}'),
                Text('Quantity: $quantity'),
                Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      _deleteProduct(context, documentId), // Add this line
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Add this method
  Future<void> _deleteProduct(BuildContext context, String documentId) async {
    // Show an AlertDialog to confirm the deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  // Perform the deletion
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(documentId)
                      .delete();

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                    ),
                  );
                } catch (e) {
                  // Close the dialog
                  Navigator.of(context).pop();

                  // Show an error message if the deletion fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting product: $e'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
