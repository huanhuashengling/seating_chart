// lib/utils/database_utils.dart
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/student.dart';
import '../models/class.dart';
import '../models/week_seat_log.dart';

class DatabaseUtils {
  static const String _databaseName = 'classroom.db';
  static const int _databaseVersion = 1;

  static const String tableStudents = 'students';
  static const String columnStudentsId = 'id';
  static const String columnStudentsName = 'name';
  static const String columnStudentsGender = 'gender';
  static const String columnStudentsClassCode = 'class_code';

  static const String tableClasses = 'classes';
  static const String columnClassesId = 'id';
  static const String columnClassesName = 'class_name';
  static const String columnClassesCode = 'class_code';
  static const String columnClassesEnterSchoolYear = 'enter_school_year';
  static const String columnClassesClassNum = 'class_num';

  static const String tableWeekSeatLog = 'week_seat_log';
  static const String columnWeekSeatLogId = 'id';
  static const String columnWeekSeatLogStudentId = 'student_id';
  static const String columnWeekSeatLogSeatNumber = 'seat_number';
  static const String columnWeekSeatLogWeek = 'week';
  static const String columnWeekSeatLogUpdateTime = 'update_time';

  static const String tableWeekEvaluateLog = 'week_evaluate_log';
  static const String columnWeekEvaluateLogId = 'id';
  static const String columnWeekEvaluateLogStudentId = 'student_id';
  static const String columnWeekEvaluateLogAnsweringScore = 'answering_score';
  static const String columnWeekEvaluateLogAssignmentScore = 'assignment_score';
  static const String columnWeekEvaluateLogDisciplineScore = 'discipline_score';
  static const String columnWeekEvaluateLogWeek = 'week';
  static const String columnWeekEvaluateLogUpdateTime = 'update_time';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableStudents (
            $columnStudentsId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnStudentsName TEXT NOT NULL,
            $columnStudentsGender TEXT NOT NULL,
            $columnStudentsClassCode TEXT NOT NULL
          )
        ''')
        .then((_) {
          return db.execute('''
            CREATE TABLE $tableClasses (
              $columnClassesId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnClassesName TEXT NOT NULL,
              $columnClassesCode TEXT NOT NULL,
              $columnClassesEnterSchoolYear TEXT NOT NULL,
              $columnClassesClassNum INTEGER NOT NULL
            )
          ''');
        })
        .then((_) {
          return db.execute('''
            CREATE TABLE $tableWeekSeatLog (
              $columnWeekSeatLogId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnWeekSeatLogStudentId INTEGER NOT NULL,
              $columnWeekSeatLogSeatNumber TEXT NOT NULL,
              $columnWeekSeatLogWeek INTEGER NOT NULL,
              $columnWeekSeatLogUpdateTime TEXT NOT NULL,
              FOREIGN KEY ($columnWeekSeatLogStudentId) REFERENCES $tableStudents($columnStudentsId)
            )
          ''');
        })
        .then((_) {
          return db.execute('''
            CREATE TABLE $tableWeekEvaluateLog (
              $columnWeekEvaluateLogId INTEGER PRIMARY KEY AUTOINCREMENT,
              $columnWeekEvaluateLogStudentId INTEGER NOT NULL,
              $columnWeekEvaluateLogAnsweringScore INTEGER NOT NULL,
              $columnWeekEvaluateLogAssignmentScore INTEGER NOT NULL,
              $columnWeekEvaluateLogDisciplineScore INTEGER NOT NULL,
              $columnWeekEvaluateLogWeek INTEGER NOT NULL,
              $columnWeekEvaluateLogUpdateTime TEXT NOT NULL,
              FOREIGN KEY ($columnWeekEvaluateLogStudentId) REFERENCES $tableStudents($columnStudentsId)
            )
          ''');
        });
      },
    );
  }

// 修改这个方法，让它返回插入学生的 id
  Future<int> insertStudent(Student student) async {
    final db = await database;
    return await db.insert(
      tableStudents,
      {
        columnStudentsName: student.name,
        columnStudentsGender: student.gender,
        columnStudentsClassCode: student.classCode,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertWeekSeatLog(WeekSeatLog weekSeatLog) async {
    final db = await database;
    await db.insert(
      tableWeekSeatLog,
      weekSeatLog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WeekSeatLog>> getWeekSeatLog() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableWeekSeatLog);
    return List.generate(maps.length, (i) {
      return WeekSeatLog(
        id: maps[i][columnStudentsId],
        studentId: maps[i][columnWeekSeatLogStudentId],
        seatNumber: maps[i][columnWeekSeatLogSeatNumber],
        week: maps[i][columnWeekSeatLogWeek],
        updateTime: maps[i][columnWeekSeatLogUpdateTime],
      );
    });
  }

  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableStudents);
    return List.generate(maps.length, (i) {
      return Student(
        id: maps[i][columnStudentsId],
        name: maps[i][columnStudentsName],
        gender: maps[i][columnStudentsGender],
        classCode: maps[i][columnStudentsClassCode],
      );
    });
  }

  // 插入班级信息的方法
  Future<void> insertClass(Class newClass) async {
    final db = await database;
    await db.insert(
      tableClasses,
      {
        columnClassesName: newClass.name,
        columnClassesCode: newClass.classCode,
        columnClassesEnterSchoolYear: newClass.enterSchoolYear,
        columnClassesClassNum: newClass.classNum,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 新增方法：清空指定表的数据
  Future<void> clearTables() async {
    final db = await database;
    await db.delete(tableStudents);
    await db.delete(tableClasses);
    await db.delete(tableWeekSeatLog);
    print('数据表 students、classes 和 week_seat_log 已清空');
  }

}