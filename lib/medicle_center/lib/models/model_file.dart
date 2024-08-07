class FileModel {
  final String name;
  final String type;
  final String url;
  final String size;

  FileModel({
    this.name,
    this.type,
    this.url,
    this.size,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    final arrayName = json['name'].split('.');
    return FileModel(
      name: arrayName[0],
      type: arrayName[1],
      url: json['url'],
      size: json['size'],
    );
  }
}
