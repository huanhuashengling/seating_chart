import 'package:flutter/material.dart';

class WeekEvaluateLog {
  int? id;
  int studentId;
  int answeringScore;
  int assignmentScore;
  int disciplineScore;
  int week;
  DateTime updateTime;

  WeekEvaluateLog({
    this.id,
    required this.studentId,
    required this.answeringScore,
    required this.assignmentScore,
    required this.disciplineScore,
    required this.week,
    required this.updateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'answering_score': answeringScore,
      'assignment_score': assignmentScore,
      'discipline_score': disciplineScore,
      'week': week,
      'update_time': updateTime.toIso8601String(),
    };
  }

  factory WeekEvaluateLog.fromMap(Map<String, dynamic> map) {
    return WeekEvaluateLog(
      id: map['id'],
      studentId: map['student_id'],
      answeringScore: map['answering_score'],
      assignmentScore: map['assignment_score'],
      disciplineScore: map['discipline_score'],
      week: map['week'],
      updateTime: DateTime.parse(map['update_time']),
    );
  }
}