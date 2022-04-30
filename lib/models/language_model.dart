class LanguageModel {
  String? id;
  String? language_name;
  String? language_icon;
  String? language_code;
  String? language_collection;
  String? language_name_en;
  String? language_name_id;

  LanguageModel(
      {this.id,
      this.language_code,
      this.language_icon,
      this.language_name,
      this.language_collection,
      this.language_name_en,
      this.language_name_id});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    language_name = json['language_name'];
    language_icon = json['language_icon'];
    language_code = json['language_code'];
    language_collection = json['language_collection'];
    language_name_en = json['language_name_en'];
    language_name_id = json['language_name_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'language_name': language_name,
      'language_icon': language_icon,
      'language_code': language_code,
      'language_collection': language_collection,
      'language_name_en': language_name_en,
      'language_name_id': language_name_id
    };
  }
}

class UninitializedLanguageModel extends LanguageModel {}
