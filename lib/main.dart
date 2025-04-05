// lib/main.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/class.dart';
import 'models/student.dart';
import 'screens/class_list_screen.dart';
import 'utils/database_utils.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await deleteDatabaseFile(); // 删除旧的数据库文件
  final dbUtils = DatabaseUtils();
  List<Student> allStudents = await dbUtils.getStudents();
  allStudents = [];
  print(allStudents);

  if (allStudents.isEmpty) {
    try {
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
          print("line 31 className " + className+" name "+name+" seatNumber  "+seatNumber+"  gender "+gender);
          if (name.isNotEmpty && ['男', '女'].contains(gender)) {
            Student student = Student(
              name: name,
              seatNumber: seatNumber,
              gender: gender,
              className: className,
            );
            print("line 38 " + student.toString());
            await dbUtils.insertStudent(student);
          }
        }
      }
    } catch (e) {
      print('读取文件时出错: $e');
    }
    allStudents = await dbUtils.getStudents();
  }

  // 初始化多个班级的数据
  List<Class> allClasses = [];
  final classNames = allStudents.map((student) => student.className).toSet();
  for (var className in classNames) {
    List<Student> classStudents = allStudents.where((student) => student.className == className).toList();
    Class newClass = Class(name: className, students: classStudents);
    newClass.saveSeatingToHistory(1); // 保存第 1 周的座次记录
    allClasses.add(newClass);
  }

  runApp(MyApp(classes: allClasses));
}

Future<void> deleteDatabaseFile() async {
  String path = join(await getDatabasesPath(), 'classroom.db');
  File databaseFile = File(path);
  if (await databaseFile.exists()) {
    await databaseFile.delete();
    print('数据库文件已删除');
  }
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
      home: ClassListScreen(classes: classes, currentWeek: 1),
    );
  }
}