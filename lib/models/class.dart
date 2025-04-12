import 'dart:convert';
import 'student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Class {
  final String name;
  List<Student> students;
  // 存储每周的座次记录，键为周数，值为学生座位信息映射
  Map<int, Map<String, Student>> seatingHistory = {};

  Class({
    required this.name,
    required this.students,
  });

  // 保存当前座次表到历史记录
  void saveSeatingToHistory(int week) {
    Map<String, Student> seatingMap = {};
    for (var student in students) {
      seatingMap[student.seatNumber] = student;
    }
    seatingHistory[week] = seatingMap;
    _saveSeatingHistoryToStorage();
  }

  // 获取指定周的座次表
  Map<String, Student>? getSeatingFromHistory(int week) {
    return seatingHistory[week];
  }

  // 保存座次历史记录到本地存储
  Future<void> _saveSeatingHistoryToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> historyMap = {};
    seatingHistory.forEach((week, seatingMap) {
      Map<String, dynamic> weekMap = {};
      seatingMap.forEach((seatNumber, student) {
        weekMap[seatNumber] = student.toMap();
      });
      historyMap[week.toString()] = weekMap;
    });
    String jsonString = json.encode(historyMap);
    prefs.setString('seating_history_$name', jsonString);
  }

  // 从本地存储加载座次历史记录
  Future<void> loadSeatingHistoryFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('seating_history_$name');
    if (jsonString != null) {
      Map<String, dynamic> historyMap = json.decode(jsonString);
      historyMap.forEach((weekStr, weekMap) {
        int week = int.parse(weekStr);
        Map<String, Student> seatingMap = {};
        (weekMap as Map<String, dynamic>).forEach((seatNumber, studentMap) {
          Student student = Student.fromMap(studentMap);
          seatingMap[seatNumber] = student;
        });
        seatingHistory[week] = seatingMap;
      });
    }
  }
}