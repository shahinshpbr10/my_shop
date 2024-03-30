import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart'; // Ensure this file exists and has a TColors class

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  double _productPrice = 0.0;
  String _productDescription = '';

  // Example method to add product - ensure you implement ProductService accordingly
  void _addProduct() {
    final product = Product(
      name: _productName,
      price: _productPrice,
      description: _productDescription,
    );
    ProductService.addProduct(product).then((result) {
      if (result) {
        // Product added successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.dark, // Use your actual color
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: Theme.of(context)
              .textTheme
              .headlineLarge, // Define this style in your theme
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Name'),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Price'),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Product Description'),
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Call the method to add the product to the store
                    _addProduct();
                  }
                },
                child: Text('Submit Product'),
              ),
            ],
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

  Product({required this.name, required this.price, required this.description});
}

// Mock ProductService class - implement this based on your backend or database
class ProductService {
  static Future<bool> addProduct(Product product) async {
    // Logic to add the product to your store or database
    return true; // Return true on success, false on failure
  }
}
