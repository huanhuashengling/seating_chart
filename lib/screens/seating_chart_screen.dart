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

    return Column( // 48行开始
      // 创建一个垂直布局的Column组件
      children: [ // 定义Column组件的子组件列表
        Expanded(
          // 该Expanded组件会占据剩余的垂直空间，这里先空着，可能后续用于添加其他内容
          child: Container(),
        ),
        Table(
          // 创建一个表格组件，用于展示座位表
          border: TableBorder.all(color: Colors.grey), // 为表格添加灰色边框
          columnWidths: {
            // 定义表格第一列的宽度为固定的30像素
            0: FixedColumnWidth(30),
          },
          children: [
            // 生成表格的行，从第1行到第rows - 1行（这里是从第1行到第8行）
            ...List.generate(rows - 1, (index) {
              final row = rows - 2 - index; // 计算当前行的索引
              return TableRow(
                // 创建一个表格行
                children: [
                  // 表格的第一列，显示行号
                  Center(child: Text('${row + 1}')),
                  // 生成表格的列，从第1列到第cols - 1列（这里是从第1列到第8列）
                  ...List.generate(cols - 1, (col) {
                    final seatNumber = '${col + 1}${row + 1}'; // 生成座位号
                    final student = seatingMap[seatNumber]; // 根据座位号从座位映射中获取学生信息
                    if (student != null) {
                      // 如果该座位有学生
                      return LayoutBuilder(
                        // 使用LayoutBuilder来获取当前单元格的约束信息
                        builder: (context, constraints) {
                          if (cellHeight == null) {
                            // 如果还没有记录单元格的高度，则记录当前单元格的最大高度
                            cellHeight = constraints.maxHeight;
                            debugPrint('Cell height: $cellHeight');
                          }
                          return DragTarget<Student>(
                            // 创建一个可接收拖动对象的目标区域
                            onAccept: (draggedStudent) {
                              // 当有拖动对象被接受时，执行交换座位的操作
                              if (widget.isDraggable) {
                                _swapSeats(student, draggedStudent);
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Draggable<Student>(
                                // 创建一个可拖动的对象
                                data: student, // 拖动的数据为当前学生对象
                                child: StudentCell(
                                  // 正常显示的学生单元格
                                  student: student,
                                  onScoreChanged: _onScoreChanged,
                                ),
                                feedback: StudentCell(
                                  // 拖动时显示的反馈单元格
                                  student: student,
                                  onScoreChanged: _onScoreChanged,
                                ),
                                childWhenDragging: Container(
                                  // 拖动时原位置显示的占位容器
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
                      // 如果该座位没有学生
                      return DragTarget<Student>(
                        // 创建一个可接收拖动对象的目标区域
                        onAccept: (draggedStudent) {
                          // 当有拖动对象被接受时，更新该学生的座位号并保存座位信息
                          if (widget.isDraggable) {
                            draggedStudent.seatNumber = seatNumber;
                            widget.currentClass.saveSeatingToHistory(widget.currentWeek);
                            setState(() {});
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            // 显示一个空的容器表示该座位为空
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
              // 创建表格的最后一行，用于显示列号
              children: [
                const SizedBox.shrink(), // 第一列空着
                // 生成列号
                ...List.generate(cols - 1, (col) => Center(child: Text('${col + 1}'))),
              ],
            ),
          ],
        ),
      ],
    ); // 128行结束
  }
}