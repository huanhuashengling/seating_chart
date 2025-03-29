import 'package:flutter/material.dart';
import '../models/class.dart';
import '../widgets/student_cell.dart';

class SeatingChartScreen extends StatefulWidget {
  final Class currentClass;
  final int currentWeek;

  const SeatingChartScreen({Key? key, required this.currentClass, required this.currentWeek})
      : super(key: key);

  @override
  _SeatingChartScreenState createState() => _SeatingChartScreenState();
}

class _SeatingChartScreenState extends State<SeatingChartScreen> {
  @override
  Widget build(BuildContext context) {
    final rows = 2;
    final cols = 8;
    final seatingMap = widget.currentClass.getSeatingFromHistory(widget.currentWeek) ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentClass.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // 行序号
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(rows, (row) => Text('${rows - row}')),
                  ],
                ),
                Expanded(
                  child: Transform(
                    transform: Matrix4.rotationX(3.14159), // 上下翻转
                    alignment: Alignment.center,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        childAspectRatio: 1 / (2 / 3), // 高度减少三分之一
                      ),
                      itemCount: rows * cols,
                      itemBuilder: (context, index) {
                        final row = index ~/ cols;
                        final col = index % cols;
                        final seatNumber = '${col + 1}${rows - row}';
                        final student = seatingMap[seatNumber];
                        return Transform(
                          transform: Matrix4.rotationX(3.14159), // 上下翻转单个单元格
                          alignment: Alignment.center,
                          child: StudentCell(
                            student: student,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 组号
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 30), // 为行序号留出空间
              ...List.generate(cols, (col) => Text('${col + 1}组')),
            ],
          ),
        ],
      ),
    );
  }
}