import 'package:bbeter/pages/mental_topics/socialphobia/sociophobia_advice_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'topic_detail_scaffold.dart';

import 'day_plan_page.dart';
import 'congrats_page.dart';

// репозиторій читання JSON з assets
import 'package:bbeter/data/tasks_repository.dart';

class SociophobiaPage extends StatelessWidget {
  const SociophobiaPage({super.key});

  static const String topicId = 'sociophobia';
  static const Color accent = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    final repo = TasksRepository('lib/data/sociophobia_tasks.json');

    return TopicDetailScaffold(
      title: 'Sociophobia',
      accent: accent,
      bigIcon: Icons.group_outlined,

      // START: якщо сьогодні вже виконано — одразу екран-вітання; інакше читаємо JSON і відкриваємо план дня
      onStart: () async {
        if (await DayPlanPage.isCompletedToday(topicId)) {
          if (!context.mounted) return;
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CongratsPage(title: 'Sociophobia')));
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
                DayPlanPage(topicId: topicId, title: 'Sociophobia (Day $day)', tasks: tasks),
          ),
        );
      },

      // ADVICE → сторінка з двома картками (яку ми робили вище)
      onAdvice: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SociophobiaAdvicePage(accent: accent)));
      },

      // OPTIONAL: повідомлення/нагадування (поки заглушка)
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

      // RESET (іконка на великій картці)
      onReset: () async {
        final ok =
            await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF1E2740),
                title: const Text('Обнулити процес?', style: TextStyle(color: Colors.white)),
                content: const Text(
                  'Ви точно хочете обнулити процес? Стрік і прогрес за всі дні буде скинуто.',
                  style: TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Ні')),
                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Так')),
                ],
              ),
            ) ??
            false;

        if (ok) {
          await _resetTopicProgress(topicId);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Прогрес для Sociophobia обнулено')));
          }
        }
      },
    );
  }
}

// ——— helpers ———

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
