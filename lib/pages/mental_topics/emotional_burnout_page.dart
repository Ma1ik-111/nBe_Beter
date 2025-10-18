import 'package:bbeter/pages/mental_topics/emotion_burnout/burnout_advice_page.dart';
import 'package:flutter/material.dart';
import 'topic_detail_scaffold.dart';
import 'day_plan_page.dart';
import 'congrats_page.dart';

import 'package:bbeter/data/tasks_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmotionalBurnoutPage extends StatelessWidget {
  const EmotionalBurnoutPage({super.key});

  static const String topicId = 'emotional_burnout';
  static const Color accent = Color(0xFFFF9548);

  @override
  Widget build(BuildContext context) {
    final repo = TasksRepository('lib/data/burnout_tasks.json');

    return TopicDetailScaffold(
      title: 'Emotional Burnout',
      accent: accent,
      bigIcon: Icons.local_fire_department_rounded,

      // RESET (кнопка в правому верхньому куті великої картки)
      onReset: () async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => const AlertDialog(
            backgroundColor: Color(0xFF1E2740),
            title: Text('Обнулити процес?', style: TextStyle(color: Colors.white)),
            content: Text(
              'Ви точно хочете обнулити процес? Стрік і прогрес за всі дні буде скинуто.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(child: Text('Ні'), onPressed: null), // буде перевизначено нижче
              TextButton(child: Text('Так'), onPressed: null),
            ],
          ),
        );
        // Правильний builder з діями (де Navigator.pop повертає bool):
        // (деякі IDE зрізають лямбди вгорі; якщо треба, заміни попередній builder цим:)
        // builder: (_) => AlertDialog(
        //   backgroundColor: const Color(0xFF1E2740),
        //   title: const Text('Обнулити процес?', style: TextStyle(color: Colors.white)),
        //   content: const Text(
        //     'Ви точно хочете обнулити процес? Стрік і прогрес за всі дні буде скинуто.',
        //     style: TextStyle(color: Colors.white70),
        //   ),
        //   actions: [
        //     TextButton(onPressed: () => Navigator.pop(_, false), child: const Text('Ні')),
        //     TextButton(onPressed: () => Navigator.pop(_, true),  child: const Text('Так')),
        //   ],
        // ),

        if (ok == true) {
          await _resetTopicProgress(topicId);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Прогрес обнулено')));
          }
        }
      },

      // START: якщо сьогодні вже виконано — одразу екран-вітання; інакше читаємо JSON і відкриваємо план дня
      onStart: () async {
        if (await DayPlanPage.isCompletedToday(topicId)) {
          if (!context.mounted) return;
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CongratsPage(title: 'Emotional Burnout')));
          return;
        }

        final total = await repo.totalDays();
        final streak = await _streakUntilYesterday(topicId);
        final day = (streak % total) + 1;
        final tasks = await repo.tasksForDay(day);

        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                DayPlanPage(topicId: topicId, title: 'Emotional Burnout (Day $day)', tasks: tasks),
          ),
        );
      },

      // ADVICE: сторінка з двома картками й свайпом
      onAdvice: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const BurnoutAdvicePage(accent: accent)));
      },

      // NOTIFICATION — додаш пізніше, якщо потрібно
      onNotification: () {
        showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            backgroundColor: Color(0xFF1E2740),
            title: Text('Повідомлення', style: TextStyle(color: Colors.white)),
            content: Text(
              'Нагадування буде додано пізніше.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        );
      },
    );
  }
}

// ——— допоміжні ———

Future<void> _resetTopicProgress(String topicId) async {
  final prefs = await SharedPreferences.getInstance();
  for (final k in prefs.getKeys()) {
    if (k.startsWith('$topicId:tasks:')) {
      await prefs.remove(k);
    }
  }
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
