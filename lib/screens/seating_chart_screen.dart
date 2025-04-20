import 'package:flutter/material.dart';
import '../models/class.dart';
import '../models/student.dart';
import '../models/week_seat_log.dart';
import '../widgets/student_cell.dart';
import '../utils/database_utils.dart';


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
  Future<void> _swapSeats(Student student1, Student student2) async {
    final db = await DatabaseUtils().database;
    final now = DateTime.now();

    // 获取学生1的当前座位记录
    final seatLog1 = await db.query(
      DatabaseUtils.tableWeekSeatLog,
      where: '${DatabaseUtils.columnWeekSeatLogStudentId} = ? AND ${DatabaseUtils.columnWeekSeatLogWeek} = ?',
      whereArgs: [student1.id, widget.currentWeek],
    );

    // 获取学生2的当前座位记录
    final seatLog2 = await db.query(
      DatabaseUtils.tableWeekSeatLog,
      where: '${DatabaseUtils.columnWeekSeatLogStudentId} = ? AND ${DatabaseUtils.columnWeekSeatLogWeek} = ?',
      whereArgs: [student2.id, widget.currentWeek],
    );

    // 交换座位号
    String tempSeatNumber = seatLog1.isNotEmpty ? seatLog1.first[DatabaseUtils.columnWeekSeatLogSeatNumber] as String : '';
    String newSeatNumber1 = seatLog2.isNotEmpty ? seatLog2.first[DatabaseUtils.columnWeekSeatLogSeatNumber] as String : '';
    String newSeatNumber2 = tempSeatNumber;

    // 更新学生1的座位记录
    if (seatLog1.isNotEmpty) {
      await db.update(
        DatabaseUtils.tableWeekSeatLog,
        {
          DatabaseUtils.columnWeekSeatLogSeatNumber: newSeatNumber1,
          DatabaseUtils.columnWeekSeatLogUpdateTime: now.toIso8601String(),
        },
        where: '${DatabaseUtils.columnWeekSeatLogStudentId} = ? AND ${DatabaseUtils.columnWeekSeatLogWeek} = ?',
        whereArgs: [student1.id, widget.currentWeek],
      );
    } else {
      await db.insert(
        DatabaseUtils.tableWeekSeatLog,
        {
          DatabaseUtils.columnWeekSeatLogStudentId: student1.id,
          DatabaseUtils.columnWeekSeatLogSeatNumber: newSeatNumber1,
          DatabaseUtils.columnWeekSeatLogWeek: widget.currentWeek,
          DatabaseUtils.columnWeekSeatLogUpdateTime: now.toIso8601String(),
        },
      );
    }

    // 更新学生2的座位记录
    if (seatLog2.isNotEmpty) {
      await db.update(
        DatabaseUtils.tableWeekSeatLog,
        {
          DatabaseUtils.columnWeekSeatLogSeatNumber: newSeatNumber2,
          DatabaseUtils.columnWeekSeatLogUpdateTime: now.toIso8601String(),
        },
        where: '${DatabaseUtils.columnWeekSeatLogStudentId} = ? AND ${DatabaseUtils.columnWeekSeatLogWeek} = ?',
        whereArgs: [student2.id, widget.currentWeek],
      );
    } else {
      await db.insert(
        DatabaseUtils.tableWeekSeatLog,
        {
          DatabaseUtils.columnWeekSeatLogStudentId: student2.id,
          DatabaseUtils.columnWeekSeatLogSeatNumber: newSeatNumber2,
          DatabaseUtils.columnWeekSeatLogWeek: widget.currentWeek,
          DatabaseUtils.columnWeekSeatLogUpdateTime: now.toIso8601String(),
        },
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final rows = 9;
    final cols = 9;

    return FutureBuilder<Map<String, Student>>(
      future: widget.currentClass.getSeatingFromHistory(widget.currentWeek),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final seatingMap = snapshot.data ?? {};

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
                                  onAccept: (draggedStudent) async {
                                    if (widget.isDraggable) {
                                      await _swapSeats(student, draggedStudent);
                                    }
                                  },
                                  builder: (context, candidateData, rejectedData) {
                                    return Draggable<Student>(
                                      data: student,
                                      child: StudentCell(
                                        student: student,
                                        onScoreChanged: _onScoreChanged,
                                        currentWeek: widget.currentWeek,
                                      ),
                                      feedback: StudentCell(
                                        student: student,
                                        onScoreChanged: _onScoreChanged,
                                        currentWeek: widget.currentWeek,
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
                              onAccept: (draggedStudent) async {
                                if (widget.isDraggable) {
                                  final db = await DatabaseUtils().database;
                                  final now = DateTime.now();

                                  // 检查是否已有该学生本周的座位记录
                                  final seatLog = await db.query(
                                    DatabaseUtils.tableWeekSeatLog,
                                    where: '${DatabaseUtils.columnWeekSeatLogStudentId} = ? AND ${DatabaseUtils.columnWeekSeatLogWeek} = ?',
                                    whereArgs: [draggedStudent.id, widget.currentWeek],
                                  );

                                  if (seatLog.isNotEmpty) {
                                    await db.update(
                                      DatabaseUtils.tableWeekSeatLog,
                                      {
                                        DatabaseUtils.columnWeekSeatLogSeatNumber: seatNumber,
                                        DatabaseUtils.columnWeekSeatLogUpdateTime: now.toIso8601String(),
                                      },
                                      where: '${DatabaseUtils.columnWeekSeatLogStudentId} = ? AND ${DatabaseUtils.columnWeekSeatLogWeek} = ?',
                                      whereArgs: [draggedStudent.id, widget.currentWeek],
                                    );
                                  } else {
                                    await db.insert(
                                      DatabaseUtils.tableWeekSeatLog,
                                      {
                                        DatabaseUtils.columnWeekSeatLogStudentId: draggedStudent.id,
                                        DatabaseUtils.columnWeekSeatLogSeatNumber: seatNumber,
                                        DatabaseUtils.columnWeekSeatLogWeek: widget.currentWeek,
                                        DatabaseUtils.columnWeekSeatLogUpdateTime: now.toIso8601String(),
                                      },
                                    );
                                  }

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
      },
    );
  }
}