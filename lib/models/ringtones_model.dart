import 'dart:convert';

List<RingtonesModel>? ringtonesModelFromJson(String str) => List<RingtonesModel>.from(json.decode(str).map((x) => RingtonesModel.fromJson(x)));
String ringtonesModelToJson(List<RingtonesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RingtonesModel
{
  String? audioLink;
  String? audioName;

  RingtonesModel({this.audioLink, this.audioName});

  RingtonesModel.fromJson(Map<String, dynamic> json)
  {
    audioLink = json['audio_link'];
    audioName = json['audio_name'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audio_link'] = audioLink;
    data['audio_name'] = audioName;
    return data;
  }
}
