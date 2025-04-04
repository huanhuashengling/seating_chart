import 'package:flutter/material.dart';
import '../models/class.dart';
import '../models/student.dart';
import '../widgets/student_cell.dart';

class SeatingChartScreen extends StatefulWidget {
  final Class currentClass;
  final int currentWeek;
  final bool isDraggable; // 新增：接收是否可拖动状态

  const SeatingChartScreen({
    Key? key,
    required this.currentClass,
    required this.currentWeek,
    required this.isDraggable,
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

  // 交换两个学生的座位
  void _swapSeats(Student student1, Student student2) {
    String tempSeatNumber = student1.seatNumber;
    student1.seatNumber = student2.seatNumber;
    student2.seatNumber = tempSeatNumber;
    widget.currentClass.saveSeatingToHistory(widget.currentWeek);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final rows = 9;
    final cols = 9;
    final seatingMap = widget.currentClass.getSeatingFromHistory(widget.currentWeek) ?? {};

    return Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: {
            0: FixedColumnWidth(30),
          },
          children: [
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
                          return DragTarget<Student>(
                            onAccept: (draggedStudent) {
                              if (widget.isDraggable) {
                                _swapSeats(student, draggedStudent);
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Draggable<Student>(
                                data: student,
                                child: StudentCell(
                                  student: student,
                                  onScoreChanged: _onScoreChanged,
                                ),
                                feedback: StudentCell(
                                  student: student,
                                  onScoreChanged: _onScoreChanged,
                                ),
                                childWhenDragging: Container(
                                  height: 70.0,
                                  margin: const EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return DragTarget<Student>(
                        onAccept: (draggedStudent) {
                          if (widget.isDraggable) {
                            draggedStudent.seatNumber = seatNumber;
                            widget.currentClass.saveSeatingToHistory(widget.currentWeek);
                            setState(() {});
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            height: 70.0,
                            margin: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey),
                            ),
                          );
                        },
                      );
                    }
                  }),
                ],
              );
            }),
            TableRow(
              children: [
                const SizedBox.shrink(),
                ...List.generate(cols - 1, (col) => Center(child: Text('${col + 1}'))),
              ],
            ),
          ],
        ),
      ],
    );
  }
}