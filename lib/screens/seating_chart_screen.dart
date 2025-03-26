import 'package:flutter/material.dart';
import '../models/class.dart';
import '../widgets/student_cell.dart';

class SeatingChartScreen extends StatefulWidget {
  final List<Class> classes;

  const SeatingChartScreen({Key? key, required this.classes})
      : super(key: key);

  @override
  _SeatingChartScreenState createState() => _SeatingChartScreenState();
}

class _SeatingChartScreenState extends State<SeatingChartScreen> {
  int _selectedClassIndex = 0;

  void _onStudentMoved(int fromRow, int fromCol, int toRow, int toCol) {
    setState(() {
      widget.classes[_selectedClassIndex].moveStudent(
          fromRow, fromCol, toRow, toCol);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentClass = widget.classes[_selectedClassIndex];
    final rows = currentClass.seatingChart.length;
    final cols = currentClass.seatingChart[0].length;

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              _selectedClassIndex = index;
            });
          },
          tabs: List.generate(widget.classes.length, (index) {
            return Tab(text: '20220${index + 1}班');
          }),
        ),
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
                        final student =
                            currentClass.seatingChart[row][col];
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
    