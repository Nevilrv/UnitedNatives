class ImageModel {
  int? id;
  String? full;
  String? thumb;

  ImageModel({
    this.id,
    this.full,
    this.thumb,
  });

  void update(ImageModel item) {
    id = item.id;
    full = item.full;
    thumb = item.thumb;
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      full: json['full']['url'] ?? '',
      thumb: json['thumb']['url'] ?? '',
    );
  }

  factory ImageModel.fromJsonUpload(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0,
      thumb: json['media_details']['sizes']['thumbnail']['source_url'] ?? '',
      full: json['media_details']['sizes']['full']['source_url'] ?? '',
    );
  }
}
