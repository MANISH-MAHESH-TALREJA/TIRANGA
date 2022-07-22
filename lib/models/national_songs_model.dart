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
