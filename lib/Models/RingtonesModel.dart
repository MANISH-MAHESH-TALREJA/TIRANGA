class RingtonesModel
{
  String audioLink;
  String audioName;

  RingtonesModel({this.audioLink, this.audioName});

  RingtonesModel.fromJson(Map<String, dynamic> json)
  {
    audioLink = json['audio_link'];
    audioName = json['audio_name'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['audio_link'] = this.audioLink;
    data['audio_name'] = this.audioName;
    return data;
  }
}
