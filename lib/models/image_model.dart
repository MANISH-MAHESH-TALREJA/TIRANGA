import 'dart:convert';

List<ImageModel>? imageModelFromJson(String str) => List<ImageModel>.from(json.decode(str).map((x) => ImageModel.fromJson(x)));
String imageModelToJson(List<ImageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel
{
  String? wallpaperImages;

  ImageModel({this.wallpaperImages});

  ImageModel.fromJson(Map<String, dynamic> json)
  {
    wallpaperImages = json['wallpaper_images'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallpaper_images'] = wallpaperImages;
    return data;
  }
}
