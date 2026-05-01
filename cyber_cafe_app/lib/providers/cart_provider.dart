import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/drink.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String _deliveryAddress = '';
  static const double _baseDeliveryCharge = 2.00;

  List<CartItem> get items => List.unmodifiable(_items);
  String get deliveryAddress => _deliveryAddress;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(Drink drink) {
    final index = _items.indexWhere((item) => item.drink.id == drink.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(drink: drink));
    }
    notifyListeners();
  }

  void removeFromCart(String id) {
    _items.removeWhere((item) => item.drink.id == id);
    notifyListeners();
  }

  void incrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.drink.id == id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String id) {
    final index = _items.indexWhere((item) => item.drink.id == id);
    if (index >= 0) {
      if (_items[index].quantity <= 1) {
        _items.removeAt(index);
      } else {
        _items[index].quantity--;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _deliveryAddress = '';
    notifyListeners();
  }

  void setDeliveryAddress(String address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  double get subtotal {
    return _items.fold(0.0, (sum, item) => sum + item.drink.price * item.quantity);
  }

  double get deliveryCharge {
    if (_items.isEmpty) return 0.0;
    // Delivery charge increases slightly with subtotal
    if (subtotal > 20) return _baseDeliveryCharge * 1.5;
    return _baseDeliveryCharge;
  }

  double get totalAmount => subtotal + deliveryCharge;

  bool isInCart(String drinkId) {
    return _items.any((item) => item.drink.id == drinkId);
  }

  int quantityOf(String drinkId) {
    try {
      return _items.firstWhere((item) => item.drink.id == drinkId).quantity;
    } catch (_) {
      return 0;
    }
  }
}