enum TransactionStatus {
  pending,
  completed,
  cancelled,
  refunded,
  partiallyRefunded,
  failed,
  processing;

  String get displayName {
    switch (this) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.refunded:
        return 'Refunded';
      case TransactionStatus.partiallyRefunded:
        return 'Partially Refunded';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.processing:
        return 'Processing';
    }
  }

  bool get isActive {
    return [
      TransactionStatus.pending,
      TransactionStatus.processing,
    ].contains(this);
  }

  bool get isCompleted {
    return [
      TransactionStatus.completed,
      TransactionStatus.refunded,
      TransactionStatus.partiallyRefunded,
    ].contains(this);
  }

  bool get isFailed {
    return [
      TransactionStatus.cancelled,
      TransactionStatus.failed,
    ].contains(this);
  }
}