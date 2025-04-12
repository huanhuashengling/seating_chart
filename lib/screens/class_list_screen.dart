import 'package:flutter/material.dart';
import '../models/class.dart';
import 'seating_chart_screen.dart';

class ClassListScreen extends StatefulWidget {
  final List<Class> classes;
  final int currentWeek;

  const ClassListScreen({
    Key? key,
    required this.classes,
    required this.currentWeek,
  }) : super(key: key);

  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  int _selectedClassIndex = 0;
  bool _isToolbarExpanded = true;
  bool _isDraggable = false; // 新增：控制座位是否可拖动

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.classes.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('座次表应用'),
          bottom: TabBar(
            labelColor: Colors.white,
            onTap: (index) {
              setState(() {
                _selectedClassIndex = index;
              });
            },
            tabs: List.generate(widget.classes.length, (index) {
              return Tab(text: widget.classes[index].name);
            }),
          ),
          actions: [
            if (_isToolbarExpanded) ...[
              Row(
                children: [
                  Text('允许拖动'),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: _isDraggable,
                      onChanged: (value) {
                        setState(() {
                          _isDraggable = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('调整'),
                  SizedBox(width: 16),
                  Text('固定状态'),
                  SizedBox(width: 16),
                  Text('刷新或保存座位设置'),
                  SizedBox(width: 16),
                  Text('多选学生时显示批量评价操作'),
                ],
              ),
            ],
            IconButton(
              icon: Icon(_isToolbarExpanded
                  ? Icons.arrow_forward
                  : Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _isToolbarExpanded = !_isToolbarExpanded;
                });
              },
            ),
          ],
        ),
        body: SeatingChartScreen(
          currentClass: widget.classes[_selectedClassIndex],
          currentWeek: widget.currentWeek,
          isDraggable: _isDraggable, // 传递是否可拖动状态
        ),
      ),
    );
  }
}