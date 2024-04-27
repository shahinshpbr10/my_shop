import 'package:flutter/material.dart';
import 'package:my_shop/constants/color.dart';

class CartDetailPage extends StatelessWidget {
  final Map<int, int> cart;
  final List<Map<String, dynamic>> products;

  const CartDetailPage({
    super.key,
    required this.cart,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    double total = 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.dark,
        elevation: 0,
        title: Center(
          child: Text(
            "Cart Details",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      backgroundColor: TColors.dark,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final productId = cart.keys.elementAt(index);
                  final product =
                      products.firstWhere((p) => p['id'] == productId);
                  final quantity = cart[productId]!;
                  final itemTotal = product['price'] * quantity;
                  total += itemTotal;

                  return Card(
                    elevation: 0,
                    color: TColors.darkerGrey,
                    child: ListTile(
                      title: Text(
                        '${product['name']} (\$${product['price']})',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      subtitle: Text(
                        'Quantity: $quantity',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      trailing: Text(
                        '\$${itemTotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: TColors.darkerGrey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
