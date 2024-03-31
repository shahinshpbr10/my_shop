import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_shop/constants/color.dart';

Future<void> createProductsCollection() async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('products').doc().set({});
}

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  double _productPrice = 0.0;
  String _productDescription = '';
  int _productQuantity = 1;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    createProductsCollection(); // Call the function to create the "products" collection
  }

  Future<bool> addProduct(String shopId, Product product) async {
    try {
      // Upload the image file to Firebase Storage if available
      String? imageUrl;
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('product_images/${_imageFile!.name}');
        final file =
            File(_imageFile!.path); // Create a File object from the path
        await storageRef.putFile(file).catchError((error) {
          print('Error uploading image: $error');
          throw error; // Re-throw the error to be caught by the outer catch block
        });
        imageUrl = await storageRef.getDownloadURL();
      }

      // Add the product data to Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': product.name,
        'price': product.price,
        'description': product.description,
        'shopId': shopId,
        'imageUrl': imageUrl ?? '',
        'quantity': product.quantity,
      }).catchError((error) {
        print('Error adding product to Firestore: $error');
        throw error; // Re-throw the error to be caught by the outer catch block
      });
      return true; // Product added successfully
    } catch (e) {
      // Handle the error
      print('Error adding product: $e');
      return false;
    }
  }

  void _addProduct() async {
    final shopId = FirebaseAuth.instance.currentUser?.uid;
    if (shopId != null) {
      final product = Product(
        name: _productName,
        price: _productPrice,
        description: _productDescription,
        imageUrl: _imageFile != null ? await _uploadImageToStorage() : null,
        quantity: _productQuantity,
      );
      final result = await addProduct(shopId, product);
      if (result) {
        // Product added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product')),
        );
      }
    } else {
      // Handle the case when the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
    }
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_imageFile == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images/${_imageFile!.name}');
      final file = File(_imageFile!.path); // Create a File object from the path
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.dark,
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20.0),
                _imageFile != null
                    ? Image.file(
                        File(_imageFile!.path),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productName = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productPrice = double.parse(value!);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Product Description'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description for the product';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productDescription = value!;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Product Quantity'),
                  keyboardType: TextInputType.number,
                  initialValue: '1',
                  validator: (value) {
                    if (value == null ||
                        int.tryParse(value) == null ||
                        int.parse(value) < 1) {
                      return 'Please enter a valid quantity (greater than 0)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productQuantity = int.parse(value!);
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _selectImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _addProduct();
                    }
                  },
                  child: const Text('Submit Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String description;
  final String? imageUrl;
  final int quantity;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.quantity,
  });
}
