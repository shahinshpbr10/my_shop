import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _userAddress = '';
  int _currentStep = 0;
  String _paymentMethod = '';
  bool _isCartEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Stepper(
            currentStep: _currentStep,
            steps: [
              Step(
                title: const Text('Address'),
                content: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your delivery address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your delivery address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _userAddress = value!;
                      });
                    },
                  ),
                ),
                state: _userAddress.isEmpty
                    ? StepState.editing
                    : StepState.complete,
              ),
              Step(
                title: const Text('Order Summary'),
                content: StreamBuilder<QuerySnapshot>(
                  stream: _getCartStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final cartItems = snapshot.data!.docs;

                    if (cartItems.isEmpty) {
                      _isCartEmpty = true;
                      return const Text('Your cart is empty');
                    } else {
                      _isCartEmpty = false;
                    }

                    return Column(
                      children: cartItems.map((cartItem) {
                        final productData =
                            cartItem.data() as Map<String, dynamic>;
                        final selectedSizes =
                            List<String>.from(productData['sizes']);
                        final quantity = productData['quantity'] as int? ?? 1;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                productData['imageUrl'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productData['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('Sizes: ${selectedSizes.join(', ')}'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Qty: $quantity'),
                                        Text(
                                          '\₹${(productData['price'])}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                state: _userAddress.isEmpty
                    ? StepState.disabled
                    : StepState.complete,
              ),
              Step(
                title: const Text('Payment'),
                content: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Cash on Delivery'),
                      value: 'cod',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Online Payment'),
                      value: 'online',
                      groupValue: _paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _paymentMethod = value!;
                        });
                      },
                    ),
                  ],
                ),
                state: _paymentMethod.isEmpty
                    ? StepState.editing
                    : StepState.complete,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Deliver to:'),
                    TextButton(
                      onPressed: () {
                        _addressController.clear();
                        setState(() {
                          _userAddress = '';
                          _currentStep = 0;
                        });
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
                if (_userAddress.isNotEmpty)
                  Text(
                    _userAddress,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 16),
                const Text(
                  'Rest assured with Open Box Delivery',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Delivery agent will open the package so you can check for correct product, damage or missing items. Share OTP to accept the delivery. Why?',
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20))),
                      onPressed: () {
                        if (_currentStep == 0) {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _currentStep = 1;
                            });
                          }
                        } else if (_currentStep == 1) {
                          setState(() {
                            _currentStep = 2;
                          });
                        } else if (_currentStep == 2) {
                          if (_paymentMethod.isNotEmpty && !_isCartEmpty) {
                            _placeOrder();
                          } else if (_isCartEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Your cart is empty. Cannot place order.'),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please select a payment method to continue'),
                              ),
                            );
                          }
                        }
                      },
                      child:
                          Text(_currentStep == 2 ? 'Place Order' : 'Continue'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getCartStream() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String userId = user.uid;
      return FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }

  void _placeOrder() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String userId = user.uid;
      final cartItemsSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .get();
      final cartItems = cartItemsSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'shopId': data['shopId'], // Include the shopId
          'name': data['name'],
          'price': data['price'],
          'imageUrl': data['imageUrl'],
          'sizes': data['sizes'], // Add any other relevant product data
        };
      }).toList();

      // Group the cart items by shopId
      final itemsByShop = groupBy(cartItems, (item) => item['shopId']);

      // Create a separate order document for each shop
      for (final shopId in itemsByShop.keys) {
        final shopItems = itemsByShop[shopId]!;

        // Generate a unique order ID
        final orderId =
            FirebaseFirestore.instance.collection('orders').doc().id;

        // Create a new order document in the "orders" collection
        await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
          'userId': userId,
          'shopId': shopId, // Include the shopId for this order
          'orderId': orderId, // Include the order ID
          'address': _userAddress,
          'paymentMethod': _paymentMethod,
          'items': shopItems,
          'createdAt': FieldValue.serverTimestamp(),
          'status': 'Waiting for shop confirmation', // Initial status
        });
      }

      // Clear the cart
      final batch = FirebaseFirestore.instance.batch();
      for (final doc in cartItemsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Show a success message or navigate to a success screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
        ),
      );
    }
  }

  /// Groups the items by the given key function.
  Map<K, List<V>> groupBy<K, V>(Iterable<V> items, K Function(V) key) {
    final map = <K, List<V>>{};
    for (final item in items) {
      final itemKey = key(item);
      map.putIfAbsent(itemKey, () => []).add(item);
    }
    return map;
  }
}
