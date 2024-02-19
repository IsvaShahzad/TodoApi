import 'dart:convert';

List<Datum> datumListFromJson(String str) {
  try {
    final jsonData = json.decode(str);
    if (jsonData != null && jsonData['data'] != null) {
      Iterable dataList = jsonData['data'];
      return dataList.map((datumJson) => Datum.fromJson(datumJson)).toList();
    } else {
      throw Exception("Invalid JSON data or structure");
    }
  } catch (e) {
    print("Error parsing JSON: $e");
    return [];
  }
}


String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  bool success;
  String message;
  List<Datum> data;

  UserModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      success: json["success"],
      message: json["message"],
      data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String name;
  String description;
  bool completed;
  int v;

  Datum({
    required this.id,
    required this.name,
    required this.description,
    required this.completed,
    required this.v,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    completed: json["completed"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "completed": completed,
    "__v": v,
  };
}
