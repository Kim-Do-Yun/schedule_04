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

  void fetchSchedules() async {
    List<ScheduleModel> fetchedSchedules = await scheduleService.getAllSchedules();
    setState(() {
      schedules = fetchedSchedules;
    });
  }

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
      fetchSchedules();
    }
  }

  void deleteSchedule(int id) async {
    bool success = await scheduleService.deleteSchedule(id);
    if (success) {
      fetchSchedules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일정 관리")),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(schedules[index].title),
            subtitle: Text("${schedules[index].date} ${schedules[index].startTime} - ${schedules[index].endTime}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => deleteSchedule(schedules[index].id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewSchedule,
        child: const Icon(Icons.add),
      ),
    );
  }
}
