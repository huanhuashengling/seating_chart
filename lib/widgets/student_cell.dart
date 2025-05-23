// lib/widgets/student_cell.dart
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../models/week_evaluate_log.dart';
import '../utils/database_utils.dart';

class StudentCell extends StatelessWidget {
  final Student? student;
  final Function(Student, int, int, int) onScoreChanged;
  final int currentWeek;

  const StudentCell({
    Key? key,
    this.student,
    required this.onScoreChanged,
    required this.currentWeek,
  }) : super(key: key);

  // 显示对话框的函数
  void _showScoreDialog(BuildContext context, int disciplineDelta, int answeringDelta, int assignmentDelta) {
    if (student != null) {
      showDialog(
        context: context,
        barrierDismissible: true, // 点击对话框外可关闭
        barrierColor: Colors.black.withOpacity(0.3), // 半透明背景
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white, // 对话框背景颜色
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 对话框圆角
            ),
            elevation: 10, // 对话框阴影
            content: Container(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 新增：显示学生姓名
                  Text(
                    student?.name ?? '未知学生',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          onScoreChanged(student!, disciplineDelta, answeringDelta, assignmentDelta);
                          await _saveEvaluateLog(disciplineDelta, answeringDelta, assignmentDelta);
                          Navigator.of(context).pop(); // 关闭对话框
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // 按钮背景颜色
                          foregroundColor: Colors.white, // 按钮文字颜色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // 按钮圆角
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 按钮内边距
                          elevation: 5, // 按钮阴影
                        ),
                        child: const Text('表扬'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          onScoreChanged(student!, -disciplineDelta, -answeringDelta, -assignmentDelta);
                          await _saveEvaluateLog(-disciplineDelta, -answeringDelta, -assignmentDelta);
                          Navigator.of(context).pop(); // 关闭对话框
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // 按钮背景颜色
                          foregroundColor: Colors.white, // 按钮文字颜色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // 按钮圆角
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 按钮内边距
                          elevation: 5, // 按钮阴影
                        ),
                        child: const Text('批评'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  // 保存评价记录到数据库
  Future<void> _saveEvaluateLog(int disciplineDelta, int answeringDelta, int assignmentDelta) async {
    if (student != null) {
      final dbUtils = DatabaseUtils();
      final now = DateTime.now();
      final log = WeekEvaluateLog(
        studentId: student!.id!,
        week: currentWeek,
        disciplineScore: disciplineDelta,
        answeringScore: answeringDelta,
        assignmentScore: assignmentDelta,
        updateTime: now,
      );
      await dbUtils.insertOrUpdateWeekEvaluateLog(log);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int disciplineScore = student?.disciplineScore ?? 0;
    final int answeringScore = student?.answeringScore ?? 0;
    final int assignmentScore = student?.assignmentScore ?? 0;
    final int totalScore = disciplineScore + answeringScore + assignmentScore;
    // 根据性别设置背景颜色
    Color backgroundColor;
    if (student != null) {
      backgroundColor = student!.gender == '女' ? Colors.pink[100]! : Colors.blue[100]!;
    } else {
      backgroundColor = Colors.white;
    }
    return Container(
      margin: const EdgeInsets.all(1), // 减小 margin 来减小宽度
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        color: backgroundColor, // 设置背景颜色
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(30, 25), // 调整按钮大小
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    _showScoreDialog(context, 1, 0, 0);
                  },
                  child: Text('👮 $disciplineScore'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(30, 25), // 调整按钮大小
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    _showScoreDialog(context, 0, 1, 0);
                  },
                  child: Text('🙋 $answeringScore'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(30, 25), // 调整按钮大小
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    _showScoreDialog(context, 0, 0, 1);
                  },
                  child: Text('📚 $assignmentScore'),
                ),
              ],
            ),
          ),
          if (student != null)
            Text(
              '${student!.name} ($totalScore)',
              style: TextStyle(fontSize: 16),
            ),
        ],
      ),
    );
  }
}