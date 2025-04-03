import 'package:flutter/material.dart';
import 'models/class.dart';
import 'models/student.dart';
import 'screens/class_list_screen.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 初始化多个班级的数据
    List<Class> allClasses = [];
    for (int i = 1; i <= 3; i++) {
      List<Student> students = [];
      for (int row = 1; row <= 7; row++) {
        for (int col = 1; col <= 8; col++) {
          // 随机分配性别
          String gender = Random().nextBool() ? '男' : '女';
          students.add(Student(
            name: '学生${(row - 1) * 8 + col}',
            seatNumber: '$col$row',
            gender: gender,
          ));
        }
      }
      Class newClass = Class(name: '20220$i班', students: students);
      newClass.saveSeatingToHistory(1); // 保存第 1 周的座次记录
      allClasses.add(newClass);
    }

    return MaterialApp(
      title: '座次表应用',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClassListScreen(classes: allClasses, currentWeek: 1),
    );
  }
}    