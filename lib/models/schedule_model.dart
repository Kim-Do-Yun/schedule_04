class ScheduleModel {
  int? id;
  String title;
  String description;
  String date;
  String startTime;
  String endTime;
  bool isRecurring;
  String? recurrenceType;
  int? recurrenceInterval;
  String? recurrenceEndDate;
  String? recurrenceDays;

  ScheduleModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isRecurring = false,
    this.recurrenceType,
    this.recurrenceInterval,
    this.recurrenceEndDate,
    this.recurrenceDays,
  });

  // JSON -> 객체 변환
  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isRecurring: json['isRecurring'] ?? false,
      recurrenceType: json['recurrenceType'],
      recurrenceInterval: json['recurrenceInterval'],
      recurrenceEndDate: json['recurrenceEndDate'],
      recurrenceDays: json['recurrenceDays'],
    );
  }

  // 객체 -> JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'isRecurring': isRecurring,
      'recurrenceType': recurrenceType,
      'recurrenceInterval': recurrenceInterval,
      'recurrenceEndDate': recurrenceEndDate,
      'recurrenceDays': recurrenceDays,
    };
  }
}
