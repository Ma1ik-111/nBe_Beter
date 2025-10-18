import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class TasksRepository {
  const TasksRepository(this.assetPath);
  final String assetPath;

  Future<Map<String, dynamic>> _load() async {
    final text = await rootBundle.loadString(assetPath);
    return jsonDecode(text) as Map<String, dynamic>;
  }

  Future<int> totalDays() async {
    final data = await _load();
    return (data['days'] as List).length;
  }

  Future<List<String>> tasksForDay(int day) async {
    final data = await _load();
    final List days = data['days'] as List;
    final Map? entry = days.cast<Map>().firstWhere((e) => e['day'] == day, orElse: () => {});
    final list = (entry?['tasks'] ?? const []) as List;
    return list.map((e) => e.toString()).toList();
  }
}
