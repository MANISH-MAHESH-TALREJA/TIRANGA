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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.detail;
    data['image'] = this.image;
    data['link'] = this.link;
    return data;
  }
}
