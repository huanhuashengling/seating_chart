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
  bool _isDraggable = false; // 控制座位是否可拖动
  int _currentWeek = 1;

  @override
  void initState() {
    super.initState();
    _currentWeek = widget.currentWeek;
  }

  // 上一周
  void _previousWeek() {
    if (_currentWeek > 1) {
      setState(() {
        _currentWeek--;
      });
    }
  }

  // 下一周
  void _nextWeek() {
    final currentWeek = calculateCurrentWeek();
    if (_currentWeek < currentWeek) {
      setState(() {
        _currentWeek++;
      });
    }
  }

  // 计算当前周次
  int calculateCurrentWeek() {
    final startDate = DateTime(2025, 2, 10);
    final now = DateTime.now();
    final difference = now.difference(startDate).inDays;
    return (difference / 7).ceil() + 1;
  }

  @override
  Widget build(BuildContext context) {
    final currentWeek = calculateCurrentWeek();
    return DefaultTabController(
      length: widget.classes.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('座次表应用'),
        ),
        body: Column(
          children: [
            // 工具栏
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  Text('调整'),
                  Text('固定状态'),
                  Text('刷新或保存座位设置'),
                  Text('多选学生时显示批量评价操作'),
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: _currentWeek > 1 ? _previousWeek : null,
                  ),
                  Text(' 第 $_currentWeek 周 '),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: _currentWeek < currentWeek ? _nextWeek : null,
                  ),
                ],
              ),
            ),
            // 班级切换 TabBar
            TabBar(
              labelColor: Colors.green, // 设置已选择的班级名称颜色
              unselectedLabelColor: Colors.indigoAccent, // 设置未选择的班级名称颜色
              indicatorColor: Colors.pink, // 设置指示器颜色
              onTap: (index) {
                setState(() {
                  _selectedClassIndex = index;
                });
              },
              tabs: List.generate(widget.classes.length, (index) {
                return Tab(text: widget.classes[index].name);
              }),
            ),
            // 座位表
            Expanded(
              child: SeatingChartScreen(
                currentClass: widget.classes[_selectedClassIndex],
                currentWeek: _currentWeek,
                isDraggable: _isDraggable, // 传递是否可拖动状态
              ),
            ),
          ],
        ),
      ),
    );
  }
}