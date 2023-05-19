class ExpenseModel {
  final String id;
  final String expenseName;
  final double amount;
  final bool isPaid;

  ExpenseModel({
    required this.id,
    required this.expenseName,
    required this.amount,
    required this.isPaid,
  });
}
