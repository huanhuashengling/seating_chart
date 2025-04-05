import 'dart:io';
import 'package:path/path.dart';
import '../models/student.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseUtils {
  static Database? _database;

  // 初始化 databaseFactory
  static void _initDatabaseFactory() {
    if (Platform.isAndroid) {
      // 安卓平台无需特殊初始化
      return;
    }
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _initDatabaseFactory(); // 在获取数据库实例前初始化
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'classroom.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, disciplineScore INTEGER, answeringScore INTEGER, assignmentScore INTEGER, seatNumber TEXT, gender TEXT, className TEXT)',
        );
      },
    );
  }

  // 插入学生信息
  Future<void> insertStudent(Student student) async {
    final db = await database;
    await db.insert(
      'students',
      student.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 查询所有学生信息
  Future<List<Student>> getStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) {
      return Student.fromMap(maps[i]);
    });
  }

  // 更新学生信息
  Future<void> updateStudent(Student student) async {
    final db = await database;
    await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
}