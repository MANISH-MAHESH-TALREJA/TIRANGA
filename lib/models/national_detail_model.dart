import 'dart:convert';

List<NationalDetailModel>? nationalDetailModelFromJson(String str) => List<NationalDetailModel>.from(json.decode(str).map((x) => NationalDetailModel.fromJson(x)));
String nationalDetailModelToJson(List<NationalDetailModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NationalDetailModel
{
  String? name;
  String? detail;
  String? image;
  String? link;

  NationalDetailModel({this.name, this.detail, this.image, this.link});

  NationalDetailModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    detail = json['description'];
    image = json['image'];
    link = json['link'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = detail;
    data['image'] = image;
    data['link'] = link;
    return data;
  }
}
