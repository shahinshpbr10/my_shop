import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final double price;
  final String imageUrl;
  final List<String> selectedSizes;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.selectedSizes,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? name,
    double? price,
    String? imageUrl,
    List<String>? selectedSizes,
    int? quantity,
  }) {
    return CartItem(
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      selectedSizes: selectedSizes ?? this.selectedSizes,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartManager extends ChangeNotifier {
  final List<CartItem> _cart = [];

  void addToCart(Map<String, dynamic> productData, Set<String> selectedSizes) {
    final cartItem = CartItem(
      name: productData['name'] as String,
      price: productData['price'] as double,
      imageUrl: productData['imageUrl'] as String,
      selectedSizes: selectedSizes.toList(),
    );
    _cart.add(cartItem);
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void updateCartItemQuantity(CartItem item, int newQuantity) {
    final index = _cart.indexOf(item);
    if (index != -1) {
      _cart[index] = item.copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  List<CartItem> get cartItems => _cart;

  double get totalCost {
    return _cart.fold(
        0.0, (total, item) => total + (item.price * item.quantity));
  }
}
