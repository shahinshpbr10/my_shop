import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderDetailPage extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailPage({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final items = orderData['items'] as List<dynamic>? ?? [];
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: ListView(
        children: [
          Image.network(
            items.isNotEmpty ? items.first['imageUrl'] : '',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Address: ${orderData['address']}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Payment Method: ${orderData['paymentMethod']}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Total Items: ${items.length}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Items:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                ...items.map(
                  (item) => ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Price: ${item['price']}'),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Status: ${orderData['status']}',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showUndoOrderDialog(context, userId),
                    child: const Text('Cancel the order'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showUndoOrderDialog(
      BuildContext context, String? userId) async {
    final orderDocId = orderData['id'];
    final TextEditingController _nameController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter the correct name to cancel this order.'),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter name',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                if (_nameController.text.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(orderDocId)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Order cancel successfully')),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error undoing order: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter the correct name')),
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
