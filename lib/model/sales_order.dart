class SalesOrder {
  final int? id;
  final String customer;
  final int amount;
  final String status;
  final String date;
  final int? quantity;

  SalesOrder({
    this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.date,
    this.quantity,
  });
}
