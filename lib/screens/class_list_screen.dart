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
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Theme.of(context).primaryColor,
              child: TabBar(
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
            ),
          ),
        ),
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: SeatingChartScreen(
                currentClass: widget.classes[_selectedClassIndex],
                currentWeek: widget.currentWeek,
                isDraggable: _isDraggable, // 传递是否可拖动状态
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isToolbarExpanded
                  ? MediaQuery.of(context).size.width / 8
                  : 30,
              color: Colors.grey[200],
              padding: _isToolbarExpanded
                  ? const EdgeInsets.all(16)
                  : EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(_isToolbarExpanded
                        ? Icons.arrow_back
                        : Icons.arrow_forward),
                    onPressed: () {
                      setState(() {
                        _isToolbarExpanded = !_isToolbarExpanded;
                      });
                    },
                  ),
                  if (_isToolbarExpanded) ...[
                    Text(
                      '工具栏',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
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
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('调整'),
                    SizedBox(height: 8),
                    Text('固定状态'),
                    SizedBox(height: 8),
                    Text('刷新或保存座位设置'),
                    SizedBox(height: 16),
                    Text('多选学生时显示批量评价操作'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}