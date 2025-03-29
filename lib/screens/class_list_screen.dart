import 'package:flutter/material.dart';
import '../models/class.dart';
import 'seating_chart_screen.dart';

class ClassListScreen extends StatefulWidget {
  final List<Class> classes;
  final int currentWeek;

  const ClassListScreen({Key? key, required this.classes, required this.currentWeek})
      : super(key: key);

  @override
  _ClassListScreenState createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  int _selectedClassIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
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
      body: SeatingChartScreen(
        currentClass: widget.classes[_selectedClassIndex],
        currentWeek: widget.currentWeek,
      ),
    );
  }
}