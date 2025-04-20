import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'student.dart';
import '../utils/database_utils.dart';
import 'package:sqflite/sqflite.dart';

class Class {
  int? id;
  String name;
  String classCode;
  String enterSchoolYear;
  int classNum;
  List<Student> students;

  Class({
    this.id,
    required this.name,
    required this.classCode,
    required this.enterSchoolYear,
    required this.classNum,
    required this.students,
  });

  // 加载座次历史记录
  Future<void> loadSeatingHistoryFromStorage() async {
    final db = await DatabaseUtils().database;
    final classStudentsIds = students.map((student) => student.id).toList();
    final seatingLogs = await db.query(
      DatabaseUtils.tableWeekSeatLog,
      where: '${DatabaseUtils.columnWeekSeatLogStudentId} IN (${classStudentsIds.join(',')})',
    );
    // 可以根据需求处理座次历史记录
    print('座次历史记录: $seatingLogs');
  }

  // 保存座次历史记录
  Future<void> saveSeatingToHistory(int week) async {
    final db = await DatabaseUtils().database;
    final now = DateTime.now();

    for (var student in students) {
      // 假设这里可以从某个地方获取学生的座位号
      final seatNumber = '11'; // 这里需要根据实际情况修改
      final seatLog = {
        DatabaseUtils.columnWeekSeatLogStudentId: student.id,
        DatabaseUtils.columnWeekSeatLogSeatNumber: seatNumber,
        DatabaseUtils.columnWeekSeatLogWeek: week,
        DatabaseUtils.columnWeekSeatLogUpdateTime: now.toIso8601String(),
      };
      await db.insert(
        DatabaseUtils.tableWeekSeatLog,
        seatLog,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    print('第 $week 周的座次记录已保存');
  }

  // 获取指定周的座次记录
  Future<Map<String, Student>> getSeatingFromHistory(int week) async {
    final db = await DatabaseUtils().database;
    final classStudentsIds = students.map((student) => student.id).toList();
    final seatingLogs = await db.query(
      DatabaseUtils.tableWeekSeatLog,
      where: '${DatabaseUtils.columnWeekSeatLogStudentId} IN (${classStudentsIds.join(',')}) AND ${DatabaseUtils.columnWeekSeatLogWeek} = ?',
      whereArgs: [week],
    );

    final seatingMap = <String, Student>{};
    for (var log in seatingLogs) {
      final studentId = log[DatabaseUtils.columnWeekSeatLogStudentId] as int;
      final seatNumber = log[DatabaseUtils.columnWeekSeatLogSeatNumber] as String;
      final student = students.firstWhere((s) => s.id == studentId);
      seatingMap[seatNumber] = student;
    }
    return seatingMap;
  }
}