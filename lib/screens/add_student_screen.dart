import 'package:flutter/material.dart';
import '../utils/database_utils.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _recordController = TextEditingController();
  final DatabaseUtils _databaseUtils = DatabaseUtils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加学生'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '学生姓名',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _recordController,
              decoration: const InputDecoration(
                labelText: '学生记录（可选）',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text;
                final record = _recordController.text;
                if (name.isNotEmpty) {
                  // 创建新的学生对象并插入数据库
                  final student = Student(name: name, record: record);
                  await _databaseUtils.insertStudent(student);
                  // 插入成功后返回座次表界面并传递成功标志
                  Navigator.pop(context, true);
                }
              },
              child: const Text('添加学生'),
            ),
          ],
        ),
      ),
    );
  }
}