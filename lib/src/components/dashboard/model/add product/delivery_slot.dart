
import 'dart:convert';

DeliverySlot deliverySlotResponseFromJson(String str) => DeliverySlot.fromJson(json.decode(str));

String deliverySlotResponseToJson(DeliverySlot data) => json.encode(data.toJson());

class DeliverySlot {
  bool success;
  String message;
  Data data;

  DeliverySlot({this.success, this.message, this.data});

  DeliverySlot.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String is24x7Open;
  List<DateTimeCollection> dateTimeCollection;

  Data(
      {this.is24x7Open,
        this.dateTimeCollection,
      });

  Data.fromJson(Map<String, dynamic> json) {
    is24x7Open = json['is24x7_open'];
    if (json['date_time_collection'] != null) {
      dateTimeCollection = new List<DateTimeCollection>();
      json['date_time_collection'].forEach((v) {
        dateTimeCollection.add(new DateTimeCollection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is24x7_open'] = this.is24x7Open;
    if (this.dateTimeCollection != null) {
      data['date_time_collection'] = this.dateTimeCollection.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DateTimeCollection {
  String label;
  List<Timeslot> timeslot;

  DateTimeCollection(
      {
        this.label,
        this.timeslot});

  DateTimeCollection.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    if (json['timeslot'] != null) {
      timeslot = new List<Timeslot>();
      json['timeslot'].forEach((v) {
        timeslot.add(new Timeslot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    if (this.timeslot != null) {
      data['timeslot'] = this.timeslot.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timeslot {
  String label;
  String value;
  bool isEnable;
  String innerText;

  Timeslot(
      {this.label,
        this.value,
        this.isEnable,
        this.innerText});

  Timeslot.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    isEnable = json['is_enable'];
    innerText = json['inner_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['is_enable'] = this.isEnable;
    data['inner_text'] = this.innerText;
    return data;
  }
}

