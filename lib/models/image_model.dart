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
