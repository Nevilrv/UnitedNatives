class BookingResourceModel {
  final String id;
  final String name;
  final int quantity;
  final num total;

  BookingResourceModel({
    this.id,
    this.name,
    this.quantity,
    this.total,
  });

  factory BookingResourceModel.fromJson(Map<String, dynamic> json) {
    return BookingResourceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      quantity: json['qty'] ?? '',
      total: json['total'] ?? '',
    );
  }
}
