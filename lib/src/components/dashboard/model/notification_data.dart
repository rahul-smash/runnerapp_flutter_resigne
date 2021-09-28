// To parse this JSON data, do
//
//     final notuficationData = notuficationDataFromJson(jsonString);

import 'dart:convert';

NotificationModel notuficationDataFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notuficationDataToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.notification,
  });

  List<Notification> notification;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        notification: json["notification"] == null
            ? null
            : List<Notification>.from(
                json["notification"].map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notification": notification == null
            ? null
            : List<dynamic>.from(notification.map((x) => x.toJson())),
      };
}

class Notification {
  Notification({
    this.id,
    this.userId,
    this.brandId,
    this.type,
    this.message,
    this.isRead,
    this.action,
    this.actionId,
    this.created,
    this.date,
    this.time,
  });

  String id;
  String userId;
  String brandId;
  String type;
  String message;
  String isRead;
  String action;
  String actionId;
  DateTime created;
  String date;
  String time;

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        type: json["type"] == null ? null : json["type"],
        message: json["message"] == null ? null : json["message"],
        isRead: json["is_read"] == null ? null : json["is_read"],
        action: json["action"] == null ? null : json["action"],
        actionId: json["action_id"] == null ? null : json["action_id"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        date: json["date"] == null ? null : json["date"],
        time: json["time"] == null ? null : json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "user_id": userId == null ? null : userId,
        "brand_id": brandId == null ? null : brandId,
        "type": type == null ? null : type,
        "message": message == null ? null : message,
        "is_read": isRead == null ? null : isRead,
        "action": action == null ? null : action,
        "action_id": actionId == null ? null : actionId,
        "created": created == null ? null : created.toIso8601String(),
        "date": date == null ? null : date,
        "time": time == null ? null : time,
      };
}
