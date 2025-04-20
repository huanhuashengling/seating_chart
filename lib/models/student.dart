class Student {
  int? id;
  String name;
  String gender;
  String classCode;
  int answeringScore = 0;
  int assignmentScore = 0;
  int disciplineScore = 0;

  Student({
    this.id,
    required this.name,
    required this.gender,
    required this.classCode,
  });

  @override
  String toString() {
    return 'Student{id: $id, name: $name, gender: $gender, classCode: $classCode}';
  }
}