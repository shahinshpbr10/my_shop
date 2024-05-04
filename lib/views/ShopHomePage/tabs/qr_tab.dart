import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_shop/common/widgets/widgets/qr_box.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int productType;
  final int quantity;
  final String shopId;
  final String imageUrl;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.productType,
    required this.quantity,
    required this.shopId,
    required this.imageUrl,
    required this.sizes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'productType': productType,
      'quantity': quantity,
      'shopId': shopId,
      'imageUrl': imageUrl,
      'sizes': sizes,
    };
  }
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _productTypeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sizesController = TextEditingController();

  File? _imageFile;
  String? _qrCodeData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Product Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Product Price',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productTypeController,
                decoration: const InputDecoration(
                  labelText: 'Product Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Product Quantity',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sizesController,
                decoration: const InputDecoration(
                  labelText: 'Sizes (comma-separated)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product sizes';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              if (_qrCodeData != null)
                SizedBox(
                  height: 200,
                  width: 200,
                  child: QrCodePrintScreen(
                    qrCodeData: _qrCodeData.toString(),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final sizes = _sizesController.text
                        .split(',')
                        .map((size) => size.trim())
                        .toList();
                    final product = Product(
                      id: UniqueKey().toString(),
                      name: _nameController.text,
                      description: _descriptionController.text,
                      price: double.parse(_priceController.text),
                      productType: int.parse(_productTypeController.text),
                      quantity: int.parse(_quantityController.text),
                      shopId: '', // Placeholder for shopId
                      imageUrl: '', // Placeholder for imageUrl
                      sizes: sizes,
                    );
                    addProductToFirebase(product);
                    _clearFormFields();
                  }
                },
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _clearFormFields() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _productTypeController.clear();
    _quantityController.clear();
    _sizesController.clear();
    _imageFile = null;
    _qrCodeData = null;
  }

  String generateQRCodeData(Product product) {
    final productJson = product.toJson();
    return jsonEncode(productJson);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> addProductToFirebase(Product product) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    final shopId = user?.uid; // Get the current user's UID

    String imageUrl = '';
    if (_imageFile != null) {
      // Upload the image file to Firebase Storage
      final storageRef =
          FirebaseStorage.instance.ref().child('product_images/${product.id}');

      try {
        final uploadTask = storageRef.putFile(_imageFile!);
        final taskSnapshot = await uploadTask.whenComplete(() {});

        // Check if the task completed successfully
        if (taskSnapshot.state == TaskState.success) {
          imageUrl = await storageRef.getDownloadURL();
        } else {
          print('Image upload failed: ${taskSnapshot.state}');
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    final qrCodeData = generateQRCodeData(product);

    final productData = {
      'id': product.id,
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'productType': product.productType,
      'quantity': product.quantity,
      'shopId': shopId, // Use the current user's UID as the shopId
      'imageUrl': imageUrl, // Store the downloaded image URL
      'sizes': product.sizes,
      'qrCode': qrCodeData,
    };

    // Store the product data in the "products" collection
    await firestore.collection('products').doc(product.id).set(productData);

    setState(() {
      _qrCodeData = qrCodeData; // Set the QR code data for display
    });
  }
}
