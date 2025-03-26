import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentCell extends StatelessWidget {
  final Student student;

  const StudentCell({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalScore = student.disciplineScore +
        student.answeringScore +
        student.assignmentScore;
    return GestureDetector(
      onTap: () {
        // 处理单点学生事件
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(30, 30),
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // 处理课堂纪律评价
                    },
                    child: const Text('👮'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(30, 30),
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // 处理举手答问评价
                    },
                    child: const Text('🙋'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(30, 30),
                      padding: const EdgeInsets.all(8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      // 处理课堂作业完成情况评价
                    },
                    child: const Text('📚'),
                  ),
                ],
              ),
            ),
            Text(
              student.name,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '合计: $totalScore 分',
            ),
          ],
        ),
      ),
    );
  }
}
    