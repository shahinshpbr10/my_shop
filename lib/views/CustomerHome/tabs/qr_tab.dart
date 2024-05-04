import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRScannerScreenCustomer extends StatefulWidget {
  const QRScannerScreenCustomer({super.key});

  @override
  _QRScannerScreenCustomerState createState() =>
      _QRScannerScreenCustomerState();
}

class _QRScannerScreenCustomerState extends State<QRScannerScreenCustomer> {
  String _scanResult = 'Unknown';
  Map<String, dynamic>? _productDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _productDetails != null
                ? Image.network(
                    _productDetails!['imageUrl'],
                    height: 200,
                    fit: BoxFit.contain,
                  )
                : const SizedBox(height: 200),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => scanQRCode(),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Start QR Scan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 24.0,
                  ),
                ),
              ),
            ),
            if (_productDetails != null) ...[
              const SizedBox(height: 30),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Details',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Name: ${_productDetails!['name']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Description: ${_productDetails!['description']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Price: ${_productDetails!['price']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _productDetails != null
                            ? () => addProductToCart(_productDetails!)
                            : null,
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 20.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> scanQRCode() async {
    String qrCodeScanRes;
    try {
      qrCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
    } catch (e) {
      qrCodeScanRes = 'Unable to scan QR code: $e';
    }

    setState(() {
      _scanResult = qrCodeScanRes;
    });

    // Fetch product details from Firestore using the scanned QR code data
    fetchProductDetailsFromFirestore(qrCodeScanRes);
  }

  Future<void> fetchProductDetailsFromFirestore(String qrCodeData) async {
    final firestore = FirebaseFirestore.instance;
    final productSnapshot = await firestore
        .collection('products')
        .where('qrCode', isEqualTo: qrCodeData)
        .get();

    if (productSnapshot.docs.isNotEmpty) {
      final productData = productSnapshot.docs.first.data();
      setState(() {
        _productDetails = productData;
      });
    } else {
      setState(() {
        _productDetails = null;
      });
      print('Product not found');
    }
  }

  Future<void> addProductToCart(Map<String, dynamic> product) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final cartDocRef = firestore.collection('cart').doc(user?.uid);

    try {
      // Check if the cart document for the current user exists
      final cartDoc = await cartDocRef.get();

      if (cartDoc.exists) {
        // If the cart document exists, update the 'products' array field
        await cartDocRef.update({
          'products': FieldValue.arrayUnion([product]),
        });
      } else {
        // If the cart document doesn't exist, create a new one
        await cartDocRef.set({
          'products': [product],
        });
      }

      // Show a success message or perform any other desired action
      print('Product added to cart successfully!');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error adding product to cart: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding product to cart'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
