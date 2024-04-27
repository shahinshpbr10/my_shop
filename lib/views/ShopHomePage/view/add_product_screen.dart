import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_shop/constants/color.dart';
import 'package:my_shop/views/ShopHomePage/view/ml_prediction.dart';

Future<void> createProductsCollection() async {
  final firestore = FirebaseFirestore.instance;
  await firestore.collection('products').doc().set({});
}

enum ProductType {
  clothing,
  shoes,
  bags,
  cosmetics,
  foodItems,
  other,
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
  ProductType? _selectedProductType;
  Set<String> _selectedSizes = {};

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
        'productType': product.productType.index, // Store the enum index
        'sizes': product.sizes, // Include the list of sizes
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
        productType: _selectedProductType ?? ProductType.other,
        sizes: _selectedSizes, // Pass the list of selected sizes
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

  Set<String> _getSizeOptions(ProductType? productType) {
    switch (productType) {
      case ProductType.clothing:
        return {'Small', 'Medium', 'Large', 'X-Large'};
      case ProductType.shoes:
        return {'5', '6', '7', '8', '9', '10'};
      case ProductType.bags:
        return {'Small', 'Medium', 'Large'};
      default:
        return {};
    }
  }

  bool _productTypeSizeRequired(ProductType? productType) {
    switch (productType) {
      case ProductType.clothing:
      case ProductType.shoes:
      case ProductType.bags:
        return true;
      default:
        return false;
    }
  }

  @override
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
                DropdownButtonFormField<ProductType>(
                  value: _selectedProductType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProductType = newValue;
                      _selectedSizes = {}; // Reset the selected sizes
                    });
                  },
                  items: ProductType.values
                      .map<DropdownMenuItem<ProductType>>((ProductType value) {
                    return DropdownMenuItem<ProductType>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Product Type',
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a product type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                SizeSelectionField(
                  availableSizes: _getSizeOptions(_selectedProductType),
                  initialSizes: _selectedSizes,
                  onChanged: (values) {
                    setState(() {
                      _selectedSizes = values;
                    });
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
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return PricePredictionForm();
                    }));
                  },
                  child: const Text('Check Price of Product Using Ml'),
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
  final ProductType productType;
  final Set<String> sizes;

  Product({
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.quantity,
    required this.productType,
    required this.sizes,
  });
}

class SizeSelectionField extends StatefulWidget {
  final Set<String> availableSizes;
  final Set<String> initialSizes;
  final ValueChanged<Set<String>> onChanged;

  const SizeSelectionField({
    super.key,
    required this.availableSizes,
    required this.initialSizes,
    required this.onChanged,
  });

  @override
  State<SizeSelectionField> createState() => _SizeSelectionFieldState();
}

class _SizeSelectionFieldState extends State<SizeSelectionField> {
  late Set<String> _selectedSizes;

  @override
  void initState() {
    super.initState();
    _selectedSizes = widget.initialSizes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Size'),
        Wrap(
          spacing: 8.0,
          children: widget.availableSizes.map((size) {
            return FilterChip(
              label: Text(size),
              selected: _selectedSizes.contains(size),
              onSelected: (isSelected) {
                setState(() {
                  if (isSelected) {
                    _selectedSizes.add(size);
                  } else {
                    _selectedSizes.remove(size);
                  }
                  widget.onChanged(_selectedSizes);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
