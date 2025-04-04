import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/schedule_model.dart';  // ✅ 올바른 모델 파일을 import

class ScheduleService {
  final String baseUrl = "http://127.0.0.1:8080/api/schedule"; // 백엔드 주소로 변경

  // 📌 일정 추가
  Future<bool> addSchedule(ScheduleModel schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(schedule.toJson()),
    );

    return response.statusCode == 200;
  }

  // 📌 일정 수정
  Future<bool> updateSchedule(int id, ScheduleModel schedule) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(schedule.toJson()),
    );

    return response.statusCode == 200;
  }

  // 📌 일정 삭제
  Future<bool> deleteSchedule(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
    );

    return response.statusCode == 200;
  }

  // 📌 특정 일정 조회
  Future<ScheduleModel?> getSchedule(int id) async {  //
    final response = await http.get(Uri.parse('$baseUrl/get/$id'));

    if (response.statusCode == 200) {
      return ScheduleModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  // 📌 전체 일정 조회
  Future<List<ScheduleModel>> getAllSchedules() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => ScheduleModel.fromJson(e)).toList();
    }
    return [];
  }
}
