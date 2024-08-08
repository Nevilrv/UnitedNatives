abstract class BookingStyleModel {
  String? price;
  int? adult;
  int? children;

  BookingStyleModel({
    this.price,
    this.adult,
    this.children,
  });

  Map<String, dynamic> get params;
}
