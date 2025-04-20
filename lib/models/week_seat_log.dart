import 'package:flutter/material.dart';

class WeekSeatLog {
  int? id;
  int studentId;
  String seatNumber;
  int week;
  DateTime updateTime;

  WeekSeatLog({
    this.id,
    required this.studentId,
    required this.seatNumber,
    required this.week,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'seat_number': seatNumber,
      'week': week,
      'update_time': updateTime.toIso8601String(),
    };
  }

  factory WeekSeatLog.fromMap(Map<String, dynamic> map) {
    return WeekSeatLog(
      id: map['id'],
      studentId: map['student_id'],
      seatNumber: map['seat_number'],
      week: map['week'],
      updateTime: DateTime.parse(map['update_time']),
    );
  }
}