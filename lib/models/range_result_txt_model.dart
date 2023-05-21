
class RangeResultTxtModel {
  int? id;
  String? name_range_id;
  String? name_range_en;
  int? range_min;
  int? range_max;

  RangeResultTxtModel(
      {this.id,
      this.name_range_en,
      this.name_range_id,
      this.range_min,
      this.range_max});

  RangeResultTxtModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name_range_id = json['name_range_id'];
    name_range_en = json['name_range_en'];
    range_min = json['range_min'];
    range_max = json['range_max'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name_range_id': name_range_id,
      'name_range_en': name_range_en,
      'range_min': range_min,
      'range_max': range_max
    };
  }
}

class UninitializedRangeResultTextModel extends RangeResultTxtModel {}
