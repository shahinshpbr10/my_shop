import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({Key? key, required this.orderData}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  String _orderStatus = 'Pending';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _orderStatus =
        widget.orderData['status'] ?? 'Waiting for shop confirmation';
    _detailsController.text = widget.orderData['details'] ?? '';
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.orderData['items'] as List<dynamic>? ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16.0),
          Card(
            color: TColors.darkContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Status',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(_orderStatus),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _orderStatus == 'Waiting for shop confirmation'
                                ? _acceptOrder
                                : null,
                        child: const Text('Accept Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green, // Set the background color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15), // Set the padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set the border radius
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16, // Set the text size
                            fontWeight: FontWeight.bold, // Set the text weight
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            _orderStatus == 'Waiting for shop confirmation'
                                ? _rejectOrder
                                : null,
                        child: const Text('Reject Order'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.red, // Set the background color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15), // Set the padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Set the border radius
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16, // Set the text size
                            fontWeight: FontWeight.bold, // Set the text weight
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            color: TColors.darkContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Details',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _detailsController,
                    decoration: const InputDecoration(
                      hintText: 'Enter order details',
                    ),
                    onChanged: (value) => _updateOrderDetails(value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            color: TColors.darkContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Address',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(widget.orderData['address']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            color: TColors.darkContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Method',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(widget.orderData['paymentMethod']),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            color: TColors.darkContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Items',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  ...items.map(
                    (item) => ListTile(
                      leading: Image.network(
                        item['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['name']),
                      subtitle: Text('\$${item['price']}'),
                      trailing: Text('Size: ${item['sizes'][0]}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _acceptOrder() async {
    _updateOrderStatus('Accepted');
  }

  void _rejectOrder() async {
    _updateOrderStatus('Rejected');
  }

  void _updateOrderStatus(String status) async {
    try {
      final documentId = widget.orderData['orderId'];
      print('Updating document with ID: $documentId');

      // Update the order status in Firestore
      await _firestore.collection('orders').doc(documentId).update({
        'status': status,
      });

      // Update the order status in the local state
      setState(() {
        _orderStatus = status;
      });
    } catch (e) {
      // Handle the error
      print('Error updating order status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating order status: $e'),
        ),
      );
    }
  }

  void _updateOrderDetails(String details) async {
    try {
      final documentId = widget.orderData['orderId'];
      print('Updating document with ID: $documentId');

      // Update the order details in Firestore
      await _firestore.collection('orders').doc(documentId).update({
        'details': details,
      });
    } catch (e) {
      // Handle the error
      print('Error updating order details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating order details: $e'),
        ),
      );
    }
  }
}
