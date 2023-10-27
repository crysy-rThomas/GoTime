import 'package:intl/intl.dart';

class ClockModel {
  int id;
  bool status;
  DateTime time;
  String description;
  int user;


  ClockModel({
    required this.id,
    required this.status,
    required this.time,
    required this.description,
    required this.user,
  });

  ClockModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        status = json['status'] ?? false,
        time = DateTime.tryParse(json['time']) ?? DateTime.now(),
        description = json['description'] ?? '',
        user = json['user'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['status'] = status;
    data['time'] = DateFormat("yyyy-mm-dd hh:mm").format(time);
    data['description'] = description;
    data['user'] = user;
    return data;
  }
}
