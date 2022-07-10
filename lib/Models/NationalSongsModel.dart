class NationalSongsModel
{
  String link;
  String name;
  String hindi;
  String english;

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['name'] = this.name;
    data['hindi'] = this.hindi;
    data['english'] = this.english;
    return data;
  }
}
