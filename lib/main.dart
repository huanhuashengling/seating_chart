// lib/main.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/class.dart';
import 'models/student.dart';
import 'models/week_seat_log.dart';
import 'screens/class_list_screen.dart';
import 'utils/database_utils.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deleteDatabaseFile();
  final dbUtils = DatabaseUtils();
  // 清空数据表
  await dbUtils.clearTables();

  List<Student> allStudents = await dbUtils.getStudents();
  allStudents = [];
  print(allStudents);

  // if (allStudents.isEmpty) {
    // try {
      String fileContent = await rootBundle.loadString('assets/students.txt');
      List<String> lines = LineSplitter.split(fileContent).toList();
      print("line 22 " + lines.toString());

      for (String line in lines) {
        List<String> parts = line.split(',');
        if (parts.length == 4) {
          String className = parts[0]?.trim()?? '';
          String name = parts[1]?.trim()?? '';
          String gender = parts[2]?.trim()?? '';
          String seatNumber = parts[3]?.trim()?? '';
          print("line 31 className " + className + " name " + name + " seatNumber  " + seatNumber + "  gender " + gender);
          if (name.isNotEmpty && ['男', '女'].contains(gender)) {
            Student student = Student(
              name: name,
              gender: gender,
              classCode: className,
            );
            print("line 38 " + student.toString());
            int studentId = await dbUtils.insertStudent(student);
            student.id = studentId;
            // 插入 WeekSeatLog 数据
            final now = DateTime.now();
            final weekSeatLog = WeekSeatLog(
              studentId: student.id!,
              seatNumber: seatNumber,
              week: 11,
              updateTime: now,
            );
            await dbUtils.insertWeekSeatLog(weekSeatLog);
          }
        }
      }
    // } catch (e) {
    //   print('读取文件时出错: $e');
    // }
    allStudents = await dbUtils.getStudents();
  // }

  // 初始化多个班级的数据
  List<Class> allClasses = [];
  final classNames = allStudents.map((student) => student.classCode).toSet();
  for (var className in classNames) {
     List<Student> classStudents = allStudents.where((student) => student.classCode == className).toList();
    // 解析 enterSchoolYear 和 classNum
    String enterSchoolYear = className.substring(0, 4);
    int classNum = int.parse(className.substring(4).replaceAll('0', ''));

    Class newClass = Class(
      name: className,
      classCode: className,
      enterSchoolYear: enterSchoolYear,
      classNum: classNum,
      students: classStudents,
    );
     // 插入班级信息到数据库
    await dbUtils.insertClass(newClass);

    // await newClass.loadSeatingHistoryFromStorage(); // 加载座次历史记录
    // final seating = await newClass.getSeatingFromHistory(11);
    // if (seating.isEmpty) {
    //   await newClass.saveSeatingToHistory(11); // 保存第 1 周的座次记录
    // }
    allClasses.add(newClass);
  }

  runApp(MyApp(classes: allClasses));
}

Future<void> deleteDatabaseFile() async {
  String path = join(await getDatabasesPath(), 'classroom.db');
  File databaseFile = File("/data/user/0/com.example.seatingchart/app_flutter/classroom.db");
  // File databaseFile = ;
  print('数据库文件路径: $path');
  if (await databaseFile.exists()) {
    await databaseFile.delete();
    print('数据库文件已删除');
  }
}

  // 计算当前周次
  int calculateCurrentWeek() {
    final startDate = DateTime(2025, 2, 10);
    final now = DateTime.now();
    final difference = now.difference(startDate).inDays;
    return (difference / 7).ceil() + 1;
  }

class MyApp extends StatelessWidget {
  final List<Class> classes;

  const MyApp({Key? key, required this.classes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '座次表应用',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ClassListScreen(classes: classes, currentWeek: calculateCurrentWeek()),
    );
  }
}