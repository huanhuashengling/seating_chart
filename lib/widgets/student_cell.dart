import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCell extends StatelessWidget {
  final Student? student;
  final Function(Student, int, int, int) onScoreChanged;

  const StudentCell({
    Key? key,
    this.student,
    required this.onScoreChanged,
  }) : super(key: key);

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
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(25, 25), // 调整按钮大小
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    if (student != null) {
                      onScoreChanged(student!, 1, 0, 0);
                    }
                  },
                  child: const Text('👮'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(25, 25), // 调整按钮大小
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    if (student != null) {
                      onScoreChanged(student!, 0, 1, 0);
                    }
                  },
                  child: const Text('🙋'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(25, 25), // 调整按钮大小
                    padding: const EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  onPressed: () {
                    if (student != null) {
                      onScoreChanged(student!, 0, 0, 1);
                    }
                  },
                  child: const Text('📚'),
                ),
              ],
            ),
          ),
          if (student != null)
            Text(
              student!.name,
              style: TextStyle(fontSize: 16),
            ),
          if (student != null)
            Text(
              '$disciplineScore  $answeringScore  $assignmentScore  $totalScore',
              style: TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }
}
    