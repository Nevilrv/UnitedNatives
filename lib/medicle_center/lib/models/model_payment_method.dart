class PaymentMethodModel {
  final String id;
  final String title;
  final String description;
  final String instruction;

  PaymentMethodModel({
    this.id,
    this.title,
    this.description,
    this.instruction,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['method'],
      title: json['title'],
      description: json['desc'],
      instruction: json['instruction'],
    );
  }
}
