class Student {
  int? id;
  final String name;
  int disciplineScore;
  int answeringScore;
  int assignmentScore;
  String seatNumber;
  String gender;
  String className;

  Student({
    this.id,
    required this.name,
    this.disciplineScore = 0,
    this.answeringScore = 0,
    this.assignmentScore = 0,
    required this.seatNumber,
    required this.gender,
    required this.className,
  }) {
    // 数据验证示例
    if (name.isEmpty) {
      throw ArgumentError('学生姓名不能为空');
    }
    if (!['男', '女'].contains(gender)) {
      throw ArgumentError('性别必须为男或女');
    }
  }

  // 计算总得分
  int get totalScore => disciplineScore + answeringScore + assignmentScore;

  // 更新学生信息
  void updateInfo({
    int? disciplineScore,
    int? answeringScore,
    int? assignmentScore,
    String? seatNumber,
    String? gender,
    String? className,
  }) {
    this.disciplineScore = disciplineScore ?? this.disciplineScore;
    this.answeringScore = answeringScore ?? this.answeringScore;
    this.assignmentScore = assignmentScore ?? this.assignmentScore;
    this.seatNumber = seatNumber ?? this.seatNumber;
    this.gender = gender ?? this.gender;
    this.className = className ?? this.className;
  }

  // 将 Student 对象转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'disciplineScore': disciplineScore,
      'answeringScore': answeringScore,
      'assignmentScore': assignmentScore,
      'seatNumber': seatNumber,
      'gender': gender,
      'className': className,
    };
  }

// lib/models/student.dart
factory Student.fromMap(Map<String, dynamic> map) {
  return Student(
    id: map['id'],
    name: map['name']?? '',
    disciplineScore: map['disciplineScore']?? 0,
    answeringScore: map['answeringScore']?? 0,
    assignmentScore: map['assignmentScore']?? 0,
    seatNumber: map['seatNumber']?? '',
    gender: map['gender']?? '',
    className: map['className']?? '',
  );
}
}