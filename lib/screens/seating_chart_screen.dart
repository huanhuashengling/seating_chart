import 'package:flutter/material.dart';
import '../models/class.dart';
import '../models/student.dart';
import '../widgets/student_cell.dart';

class SeatingChartScreen extends StatefulWidget {
  final Class currentClass;
  final int currentWeek;

  const SeatingChartScreen({
    Key? key,
    required this.currentClass,
    required this.currentWeek,
  }) : super(key: key);

  @override
  _SeatingChartScreenState createState() => _SeatingChartScreenState();
}

class _SeatingChartScreenState extends State<SeatingChartScreen> {
  double? cellHeight;

  void _onScoreChanged(Student student, int disciplineDelta, int answeringDelta, int assignmentDelta) {
    setState(() {
      student.disciplineScore += disciplineDelta;
      student.answeringScore += answeringDelta;
      student.assignmentScore += assignmentDelta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rows = 9;
    final cols = 9;
    final seatingMap = widget.currentClass.getSeatingFromHistory(widget.currentWeek) ?? {};

    return Column(
      children: [
        // 添加一个 Expanded 组件占据剩余空间
        Expanded(
          child: Container(),
        ),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: {
            0: FixedColumnWidth(30), // 行头宽度
          },
          children: [
            // 从下往上生成行
            ...List.generate(rows - 1, (index) {
              final row = rows - 2 - index; 
              return TableRow(
                children: [
                  Center(child: Text('${row + 1}')),
                  ...List.generate(cols - 1, (col) {
                    final seatNumber = '${col + 1}${row + 1}';
                    final student = seatingMap[seatNumber];
                    if (student != null) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          if (cellHeight == null) {
                            cellHeight = constraints.maxHeight;
                            debugPrint('Cell height: $cellHeight'); 
                          }
                          return StudentCell(
                            student: student,
                            onScoreChanged: _onScoreChanged,
                          );
                        },
                      );
                    } else {
                      return Container(
                        height: 70.0,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey),
                        ),
                      );
                    }
                  }),
                ],
              );
            }),
            TableRow(
              children: [
                const SizedBox.shrink(), // 左上角空白
                ...List.generate(cols - 1, (col) => Center(child: Text('${col + 1}'))),
              ],
            ),
          ],
        ),
      ],
    );
  }
}