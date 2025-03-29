import 'student.dart';

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
  }

  // 获取指定周的座次表
  Map<String, Student>? getSeatingFromHistory(int week) {
    return seatingHistory[week];
  }
}