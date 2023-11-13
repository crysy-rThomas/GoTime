import 'package:intl/intl.dart';

class WorkingModel {
  int id;
  DateTime startTime;
  DateTime endTime;

  WorkingModel({
    required this.id,
    required this.startTime,
    required this.endTime,
  });

  WorkingModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        startTime = DateTime.tryParse(json['start_time']) ?? DateTime.now(),
        endTime = DateTime.tryParse(json['end_time']) ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['start_time'] = DateFormat("yyyy-mm-dd hh:mm").format(startTime);
    data['end_time'] = DateFormat("yyyy-mm-dd hh:mm").format(endTime);
    return data;
  }
}
