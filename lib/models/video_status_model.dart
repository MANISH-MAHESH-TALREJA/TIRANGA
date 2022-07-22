class VideoStatusModel
{
  String? videoUrl;
  String? videoName;
  String? videoThumbnail;

  VideoStatusModel({this.videoUrl, this.videoName, this.videoThumbnail});

  VideoStatusModel.fromJson(Map<String, dynamic> json)
  {
    videoUrl = json['video_url'];
    videoName = json['video_name'];
    videoThumbnail = json['video_thumbnail'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_url'] = videoUrl;
    data['video_name'] = videoName;
    data['video_thumbnail'] = videoThumbnail;
    return data;
  }
}
