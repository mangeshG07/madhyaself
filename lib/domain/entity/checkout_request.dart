class CheckoutRequest {
  final String userId;
  final String planId;
  final String price;
  final String paymentMethod;
  final String type;

  CheckoutRequest(
    this.userId,
    this.planId,
    this.price,
    this.paymentMethod,
    this.type,
  );
}
