import 'student.dart';

class Class {
  final String name;
  List<List<Student>> seatingChart;
  // 存储每周的座次记录，键为周数，值为座次表
  Map<int, List<List<Student>>> seatingHistory = {};

  Class({
    required this.name,
    required this.seatingChart,
  });

  // 应用规则1
  void applyRule1() {
    final newChart = List.generate(
      seatingChart.length,
      (_) => List.filled(seatingChart[0].length, Student(name: '')),
    );
    for (int i = 0; i < seatingChart.length; i++) {
      for (int j = 0; j < seatingChart[0].length; j++) {
        final newRow = (i - 1 + seatingChart.length) % seatingChart.length;
        final newCol = (j - 2 + seatingChart[0].length) % seatingChart[0].length;
        newChart[newRow][newCol] = seatingChart[i][j];
      }
    }
    seatingChart = newChart;
  }

  // 应用规则2
  void applyRule2() {
    final newChart = List.generate(
      seatingChart.length,
      (_) => List.filled(seatingChart[0].length, Student(name: '')),
    );
    int rows = seatingChart.length;
    int cols = seatingChart[0].length;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        int newRow = (i + 1 < rows) ? i + 1 : 0;
        int newCol = (j + 1 < cols) ? j + 1 : 0;
        newChart[newRow][newCol] = seatingChart[i][j];
      }
    }
    seatingChart = newChart;
  }

  // 应用规则3
  void applyRule3() {
    final newChart = List.generate(
      seatingChart.length,
      (_) => List.filled(seatingChart[0].length, Student(name: '')),
    );
    int rows = seatingChart.length;
    int cols = seatingChart[0].length;
    int index = 0;
    for (int i = 0; i < rows; i++) {
      if (i % 2 == 0) {
        for (int j = 0; j < cols; j++) {
          int newRow = index ~/ cols;
          int newCol = index % cols;
          newChart[newRow][newCol] = seatingChart[i][j];
          index++;
        }
      } else {
        for (int j = cols - 1; j >= 0; j--) {
          int newRow = index ~/ cols;
          int newCol = index % cols;
          newChart[newRow][newCol] = seatingChart[i][j];
          index++;
        }
      }
    }
    seatingChart = newChart;
  }

  // 保存当前座次表到历史记录
  void saveSeatingToHistory(int week) {
    seatingHistory[week] = List.generate(
      seatingChart.length,
      (i) => List.from(seatingChart[i]),
    );
  }

  // 获取指定周的座次表
  List<List<Student>>? getSeatingFromHistory(int week) {
    return seatingHistory[week];
  }

  // 移动学生位置
  void moveStudent(int fromRow, int fromCol, int toRow, int toCol) {
    if (fromRow >= 0 && fromRow < seatingChart.length &&
        fromCol >= 0 && fromCol < seatingChart[0].length &&
        toRow >= 0 && toRow < seatingChart.length &&
        toCol >= 0 && toCol < seatingChart[0].length) {
      Student student = seatingChart[fromRow][fromCol];
      seatingChart[fromRow][fromCol] = Student(name: '');
      seatingChart[toRow][toCol] = student;
    }
  }
}    