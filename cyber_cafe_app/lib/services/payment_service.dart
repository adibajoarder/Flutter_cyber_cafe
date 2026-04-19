import 'dart:async';

class PaymentService {
  /// Simulates processing a payment.
  /// Returns true if payment succeeds, false otherwise.
  /// In production, integrate with a real payment gateway (Stripe, Razorpay etc.)
  Future<bool> processPayment({
    required double amount,
    required String method,
    String? cardNumber,
    String? upiId,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(seconds: 2));

    // Simulate 95% success rate
    // In production replace this with actual payment gateway SDK calls
    return true;
  }

  List<String> getPaymentMethods() {
    return ['Credit / Debit Card', 'UPI / Mobile Pay', 'Cash on Delivery'];
  }
}
