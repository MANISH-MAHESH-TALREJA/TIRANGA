import 'dart:convert';

List<NationalSongsModel>? nationalSongsModelFromJson(String str) => List<NationalSongsModel>.from(json.decode(str).map((x) => NationalSongsModel.fromJson(x)));
String nationalSongsModelToJson(List<NationalSongsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NationalSongsModel
{
  String? link;
  String? name;
  String? hindi;
  String? english;

  NationalSongsModel({this.link, this.name, this.hindi, this.english});

  NationalSongsModel.fromJson(Map<String, dynamic> json)
  {
    link = json['link'];
    name = json['name'];
    hindi = json['hindi'];
    english = json['english'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['name'] = name;
    data['hindi'] = hindi;
    data['english'] = english;
    return data;
  }
}
