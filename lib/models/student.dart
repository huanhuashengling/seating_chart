class Student {
  final String name;
  int disciplineScore;
  int answeringScore;
  int assignmentScore;
  String seatNumber;
  String gender; // 添加性别属性

  Student({
    required this.name,
    this.disciplineScore = 0,
    this.answeringScore = 0,
    this.assignmentScore = 0,
    required this.seatNumber,
    required this.gender, // 初始化性别
  });
}    