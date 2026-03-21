enum OzowPaymentStatus { success, cancelled, error, pending }

class OzowResult {
  final OzowPaymentStatus status;
  final String? transactionId;
  final String? reference;
  final String? errorMessage;
  final Map<String, String>? rawParams;

  const OzowResult({
    required this.status,
    this.transactionId,
    this.reference,
    this.errorMessage,
    this.rawParams,
  });

  bool get isSuccess => status == OzowPaymentStatus.success;
  bool get isCancelled => status == OzowPaymentStatus.cancelled;
  bool get isError => status == OzowPaymentStatus.error;
  bool get isPending => status == OzowPaymentStatus.pending;

  @override
  String toString() =>
      'OzowResult(status: $status, transactionId: $transactionId, '
      'reference: $reference, errorMessage: $errorMessage)';
}
