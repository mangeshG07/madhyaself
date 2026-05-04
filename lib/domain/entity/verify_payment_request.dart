class VerifyPaymentRequest {
  final String userId;
  final String razorpayPaymentId;
  final String razorpayOrderId;
  final String paymentId;
  final String razorpaySignature;
  final String status;

  VerifyPaymentRequest(
    this.userId,
    this.razorpayPaymentId,
    this.razorpayOrderId,
    this.paymentId,
    this.razorpaySignature,
    this.status,
  );
}
