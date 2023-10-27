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
        startTime = DateTime.tryParse(json['startTime']) ?? DateTime.now(),
        endTime = DateTime.tryParse(json['endTime']) ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['startTime'] = DateFormat("yyyy-mm-dd hh:mm").format(startTime);
    data['endTime'] = DateFormat("yyyy-mm-dd hh:mm").format(endTime);
    return data;
  }
}
