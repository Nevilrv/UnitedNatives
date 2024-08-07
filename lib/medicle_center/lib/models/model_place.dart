class PlaceModel {
  final String name;
  final String placeID;
  final String address;

  PlaceModel({
    this.name,
    this.placeID,
    this.address,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['name'] ?? '',
      placeID: json['place_id'] ?? '',
      address: json['formatted_address'] ?? '',
    );
  }
}
