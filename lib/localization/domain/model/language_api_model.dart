class LanguageItem {
  int? id;
  String? name;
  String? filePath;
  String? isDefault;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? fullPath;

  LanguageItem(
      {this.id,
        this.name,
        this.filePath,
        this.isDefault,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.fullPath});

  LanguageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    filePath = json['file_path'];
    isDefault = json['is_default'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fullPath = json['full_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['file_path'] = filePath;
    data['is_default'] = isDefault;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['full_path'] = fullPath;
    return data;
  }
}
