enum PaymentMethod {
  cash,
  creditCard,
  debitCard,
  mobileWallet,
  bankTransfer,
  giftCard,
  loyaltyPoints,
  cryptocurrency,
  checkPayment,
  other;

  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.mobileWallet:
        return 'Mobile Wallet';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.giftCard:
        return 'Gift Card';
      case PaymentMethod.loyaltyPoints:
        return 'Loyalty Points';
      case PaymentMethod.cryptocurrency:
        return 'Cryptocurrency';
      case PaymentMethod.checkPayment:
        return 'Check';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  bool get requiresChange {
    return this == PaymentMethod.cash;
  }

  bool get isDigital {
    return [
      PaymentMethod.creditCard,
      PaymentMethod.debitCard,
      PaymentMethod.mobileWallet,
      PaymentMethod.bankTransfer,
      PaymentMethod.cryptocurrency,
    ].contains(this);
  }
}