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
