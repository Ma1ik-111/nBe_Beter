import 'package:bbeter/pages/mental_topics/depression/advice_page_dep.dart';
import 'package:flutter/material.dart';
import 'topic_detail_scaffold.dart';
import 'day_plan_page.dart';

import 'congrats_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bbeter/data/tasks_repository.dart'; // твій репозиторій

class DepressionPreventionPage extends StatelessWidget {
  const DepressionPreventionPage({super.key});

  static const String topicId = 'depression_prevention';
  static const Color accent = Color(0xFF7A3EF4);

  @override
  Widget build(BuildContext context) {
    final repo = TasksRepository('lib/data/depression_tasks.json');

    return TopicDetailScaffold(
      title: 'Depression Prevention',
      accent: accent,
      bigIcon: Icons.sentiment_dissatisfied_rounded,

      // --- RESET ---
      onReset: () async {
        final ok =
            await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF1E2740),
                title: const Text('Reset the process?', style: TextStyle(color: Colors.white)),
                content: const Text(
                  'Are you sure you want to reset the process? Your streak and progress for all days will be lost.',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;

        if (!ok) return;

        await _resetTopicProgress(topicId);

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Progress has been reset.')));
        }
      },

      // --- START ---
      onStart: () async {
        // якщо СЬОГОДНІ вже виконано — одразу показуємо екран-вітання
        if (await DayPlanPage.isCompletedToday(topicId)) {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CongratsPage(title: 'Depression Prevention')),
          );
          return;
        }

        // інакше підтягуємо задачі з JSON і відкриваємо план дня
        final total = await repo.totalDays();
        final streak = await _streakUntilYesterday(topicId);
        final day = (streak % total) + 1;
        final tasks = await repo.tasksForDay(day);

        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DayPlanPage(
              topicId: topicId,
              title: 'Depression Prevention (Day $day)',
              tasks: tasks,
            ),
          ),
        );
      },

      // --- ADVICE / NOTIFICATION як було ---
      onAdvice: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const AdvicePage(accent: accent))),
      onNotification: () => showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          backgroundColor: Color(0xFF1E2740),
          title: Text('Повідомлення', style: TextStyle(color: Colors.white)),
          content: Text(
            'Нагадування буде додано пізніше.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

/// ——— допоміжні ———

Future<void> _resetTopicProgress(String topicId) async {
  final prefs = await SharedPreferences.getInstance();
  // прибрати всі ключі виду "<topicId>:tasks:YYYY-MM-DD"
  for (final k in prefs.getKeys()) {
    if (k.startsWith('$topicId:tasks:')) {
      await prefs.remove(k);
    }
  }
  // прибрати множину завершених днів
  await prefs.remove('$topicId:completedDates');
}

Future<int> _streakUntilYesterday(String topicId) async {
  final prefs = await SharedPreferences.getInstance();
  final set = (prefs.getStringList('$topicId:completedDates') ?? const <String>[]).toSet();
  String fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  int s = 0;
  var cur = DateTime.now().subtract(const Duration(days: 1));
  while (set.contains(fmt(cur))) {
    s++;
    cur = cur.subtract(const Duration(days: 1));
  }
  return s;
}
