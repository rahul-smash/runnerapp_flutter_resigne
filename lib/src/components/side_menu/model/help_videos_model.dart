// To parse this JSON data, do
//
//     final helpVideosModel = helpVideosModelFromJson(jsonString);

import 'dart:convert';

HelpVideosModel helpVideosModelFromJson(String str) => HelpVideosModel.fromJson(json.decode(str));

String helpVideosModelToJson(HelpVideosModel data) => json.encode(data.toJson());

class HelpVideosModel {
  HelpVideosModel({
    this.success,
    this.data,
  });

  bool success;
  List<HelpVideoData> data;

  factory HelpVideosModel.fromJson(Map<String, dynamic> json) => HelpVideosModel(
    success: json["success"],
    data: List<HelpVideoData>.from(json["data"].map((x) => HelpVideoData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class HelpVideoData {
  HelpVideoData({
    this.id,
    this.title,
    this.videoUrl,
  });

  String id;
  String title;
  String videoUrl;

  factory HelpVideoData.fromJson(Map<String, dynamic> json) => HelpVideoData(
    id: json["id"],
    title: json["title"],
    videoUrl: json["video_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "video_url": videoUrl,
  };
}
