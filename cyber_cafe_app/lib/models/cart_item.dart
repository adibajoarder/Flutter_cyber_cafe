import 'drink.dart';

class CartItem {
  final Drink drink;
  int quantity;

  CartItem({required this.drink, this.quantity = 1});
}