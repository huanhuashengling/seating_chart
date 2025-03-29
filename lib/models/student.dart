class Student {
  final String name;
  int disciplineScore;
  int answeringScore;
  int assignmentScore;
  String seatNumber;

  Student({
    required this.name,
    this.disciplineScore = 0,
    this.answeringScore = 0,
    this.assignmentScore = 0,
    required this.seatNumber,
  });
}