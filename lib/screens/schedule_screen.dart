import 'package:flutter/material.dart';
import '../services/schedule_service.dart';
import '../models/schedule_model.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleService scheduleService = ScheduleService();
  List<ScheduleModel> schedules = [];

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  // 📌 전체 일정 불러오기
  void fetchSchedules() async {
    List<ScheduleModel> fetchedSchedules = await scheduleService.getAllSchedules();
    setState(() {
      schedules = fetchedSchedules;
    });
  }

  // 📌 일정 추가
  void addNewSchedule() async {
    ScheduleModel newSchedule = ScheduleModel(
      title: "회의",
      description: "주간 회의",
      date: "2025-04-05",
      startTime: "10:00",
      endTime: "11:00",
    );

    bool success = await scheduleService.addSchedule(newSchedule);
    if (success) {
      fetchSchedules(); // 다시 일정 불러오기
    }
  }

  // 📌 일정 삭제
  void deleteSchedule(int id) async {
    bool success = await scheduleService.deleteSchedule(id);
    if (success) {
      fetchSchedules(); // 일정 갱신
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("일정 관리")),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(schedules[index].title),
            subtitle: Text("${schedules[index].date} ${schedules[index].startTime} - ${schedules[index].endTime}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteSchedule(schedules[index].id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewSchedule,
        child: Icon(Icons.add),
      ),
    );
  }
}
