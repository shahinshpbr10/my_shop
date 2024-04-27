import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/views/CustomerHome/pages/place_order_page.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getCartStream(),
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

          final cartItems = snapshot.data!.docs;

          if (cartItems.isEmpty) {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    final productData = cartItem.data() as Map<String, dynamic>;
                    final selectedSizes =
                        List<String>.from(productData['sizes']);
                    final quantity = productData['quantity'] as int? ?? 1;

                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              productData['imageUrl'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productData['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Sizes: ${selectedSizes.join(', ')}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: quantity > 1
                                          ? () => _updateQuantity(
                                              cartItem, quantity - 1)
                                          : null,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Text('$quantity'),
                                    IconButton(
                                      onPressed: () => _updateQuantity(
                                          cartItem, quantity + 1),
                                      icon: const Icon(Icons.add),
                                    ),
                                    IconButton(
                                      onPressed: () =>
                                          _removeFromCart(cartItem),
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildCartSummary(cartItems),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to the Place Order page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlaceOrderPage(),
                ),
              );
            },
            child: const Text('Place Order'),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getCartStream() {
    final User? user = _auth.currentUser;
    if (user != null) {
      final String userId = user.uid;
      return _firestore
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  Widget _buildCartSummary<T>(List<QueryDocumentSnapshot<T>> cartItems) {
    double totalCost = 0.0;

    for (var cartItem in cartItems) {
      final productData = cartItem.data() as Map<String, dynamic>;
      final price = productData['price'] as double;
      final quantity = productData['quantity'] as int? ?? 1;
      totalCost += price * quantity;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${totalCost.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantity(
      QueryDocumentSnapshot<Object?> cartItem, int newQuantity) {
    final documentId = cartItem.id;
    final productData = cartItem.data() as Map<String, dynamic>;

    _firestore.collection('cart').doc(documentId).update({
      'quantity': newQuantity,
    });
  }

  void _removeFromCart(QueryDocumentSnapshot<Object?> cartItem) {
    final documentId = cartItem.id;

    _firestore.collection('cart').doc(documentId).delete();
  }
}
