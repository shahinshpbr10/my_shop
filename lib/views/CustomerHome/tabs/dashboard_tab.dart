import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

class CustomerDashboardPage extends StatefulWidget {
  const CustomerDashboardPage({super.key});

  @override
  _CustomerDashboardPageState createState() => _CustomerDashboardPageState();
}

class _CustomerDashboardPageState extends State<CustomerDashboardPage> {
  final List<Map<String, dynamic>> orders = [
    {'id': 1, 'product': 'Product X', 'quantity': 2, 'total': 60.0},
    {'id': 2, 'product': 'Product Y', 'quantity': 1, 'total': 40.0},
    {'id': 3, 'product': 'Product Z', 'quantity': 3, 'total': 90.0},
    // Add more orders as needed
  ];

  final List<Map<String, dynamic>> products = [
    {'id': 1, 'name': 'Product A', 'price': 20.0},
    {'id': 2, 'name': 'Product B', 'price': 30.0},
    {'id': 3, 'name': 'Product C', 'price': 25.0},
    // Add more products as needed
  ];

  final Map<int, int> cart = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.dark,
        elevation: 0,
        title: Center(
          child: Text(
            "Dashboard",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      backgroundColor: TColors.dark,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildSectionTitle('Order Summary', Icons.receipt),
            _buildOrderSummary(),
            const SizedBox(height: 16),
            _buildSectionTitle('My Favorites', Icons.favorite),
            _buildMyFavorites(),
            const SizedBox(height: 16),
            _buildSectionTitle('Loyalty Points', Icons.star),
            _buildLoyaltyPoints(),
            const SizedBox(height: 16),
            _buildSectionTitle('My Cart', Icons.shopping_cart),
            _buildMyCart(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: TColors.white),
          const SizedBox(width: 18),
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      color: TColors.darkerGrey,
      elevation: 0,
      child: ListTile(
        title:
            Text('Total Orders', style: Theme.of(context).textTheme.labelLarge),
        subtitle: Text(orders.length.toString(),
            style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }

  Widget _buildMyFavorites() {
    // Replace this with your widget to display the customer's favorites
    // You can use a ListView.builder or another suitable widget
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: TColors.darkerGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text('List of My Favorites',
            style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }

  Widget _buildLoyaltyPoints() {
    return Card(
      elevation: 0,
      color: TColors.darkerGrey,
      child: ListTile(
        title: Text('Loyalty Points',
            style: Theme.of(context).textTheme.headlineSmall),
        subtitle:
            Text('150 Points', style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }

  Widget _buildMyCart() {
    return Container(
      color: TColors.darkGrey,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final productId = cart.keys.elementAt(index);
          final product = products.firstWhere((p) => p['id'] == productId);
          final quantity = cart[productId];

          return Card(
            elevation: 0,
            child: ListTile(
              title: Text('${product['name']} (\$${product['price']})',
                  style: Theme.of(context).textTheme.headlineLarge),
              subtitle: Text('Quantity: $quantity',
                  style: Theme.of(context).textTheme.headlineLarge),
              trailing: IconButton(
                icon: const Icon(Icons.remove_shopping_cart),
                onPressed: () {
                  _removeFromCart(productId);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _removeFromCart(int productId) {
    setState(() {
      if (cart.containsKey(productId)) {
        cart[productId] = cart[productId]! - 1;
        if (cart[productId] == 0) {
          cart.remove(productId);
        }
      }
    });
  }
}
