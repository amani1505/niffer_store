enum OrderStatus {
  pending('pending', 'Pending'),
  confirmed('confirmed', 'Confirmed'),
  processing('processing', 'Processing'),
  shipped('shipped', 'Shipped'),
  delivered('delivered', 'Delivered'),
  cancelled('cancelled', 'Cancelled'),
  refunded('refunded', 'Refunded');

  const OrderStatus(this.value, this.displayName);

  final String value;
  final String displayName;

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => OrderStatus.pending,
    );
  }
}
