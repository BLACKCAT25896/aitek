class LanguageDetailsModel {
  String name;
  String filePath;
  Map<String, String> data;

  LanguageDetailsModel({required this.name, required this.filePath, required this.data});

  factory LanguageDetailsModel.fromJson(Map<String, dynamic> json) {
    Map<String, String> dataMap = {};
    json['data'].forEach((key, value) {
      dataMap[key] = value.toString();
    });

    return LanguageDetailsModel(
      name: json['name'],
      filePath: json['file_path'],
      data: dataMap,
    );
  }
}
