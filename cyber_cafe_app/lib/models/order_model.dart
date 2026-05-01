import 'cart_item.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double total;
  final String deliveryAddress;
  final String paymentMethod;
  final DateTime placedAt;
  String status; // pending, preparing, on_the_way, delivered

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.total,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.placedAt,
    this.status = 'pending',
  });
}
