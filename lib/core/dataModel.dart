import 'dart:convert';

class DataInfo {
  int? userId;
  int? id;
  String? title;
  String? body;

  DataInfo({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory DataInfo.changToModel(Map<String, dynamic> json) {
    return DataInfo(
      userId: json["userId"] ?? json["userId"],
      id: json["id"] ?? json["id"],
      title: json["title"] ?? json["title"],
      body: json["body"] ?? json["body"],
    );
  }

  factory DataInfo.changeToJson(String data) {
    return DataInfo.changToModel(json.decode(data));
  }

  String toJson() {
    return json.encode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      "userId": userId ?? userId,
      "id": id ?? id,
      "title": title ?? title,
      "body": body ?? body,
    };
  }
}
