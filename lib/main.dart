import 'package:flutter/material.dart';
import 'screens/seating_chart_screen.dart';
import 'models/class.dart';
import 'models/student.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 初始化 7 个班级的数据
    List<Class> allClasses = [];
    for (int i = 1; i <= 7; i++) {
      List<List<Student>> seatingChart = [];
      for (int row = 0; row < 7; row++) {
        List<Student> rowStudents = [];
        for (int col = 0; col < 8; col++) {
          rowStudents.add(Student(name: '学生${(row * 8 + col + 1)}'));
        }
        seatingChart.add(rowStudents);
      }
      allClasses.add(Class(name: '20220$i班', seatingChart: seatingChart));
    }

    return MaterialApp(
      title: '座次表应用',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SeatingChartScreen(classes: allClasses),
    );
  }
}    