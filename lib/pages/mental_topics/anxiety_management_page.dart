import 'package:bbeter/pages/mental_topics/anxiety/anxiety_advice_page.dart';
import 'package:bbeter/pages/mental_topics/congrats_page.dart';
import 'package:bbeter/pages/mental_topics/day_plan_page.dart';
import 'package:bbeter/pages/mental_topics/topic_detail_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../data/tasks_repository.dart';
// 🟣 імпорт сторінки порад

class AnxietyManagementPage extends StatelessWidget {
  const AnxietyManagementPage({super.key});

  static const String topicId = 'anxiety_management';
  static const Color accent = Color(0xFF64B5F6); // ніжно-блакитний відтінок

  @override
  Widget build(BuildContext context) {
    final repo = TasksRepository('lib/data/anxiety_management_tasks.json');

    return TopicDetailScaffold(
      title: 'Anxiety Management',
      accent: accent,
      bigIcon: Icons.self_improvement_outlined,

      // 🟢 КНОПКА START
      onStart: () async {
        if (await DayPlanPage.isCompletedToday(topicId)) {
          if (!context.mounted) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CongratsPage(title: 'Anxiety Management'),
            ),
          );
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        final completedDays = prefs.getInt('${topicId}_completedDays') ?? 0;
        final nextDay = completedDays + 1;

        final tasks = await repo.tasksForDay(nextDay);

        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DayPlanPage(
              topicId: topicId,
              title: 'Anxiety Management',
              tasks: tasks,
            ),
          ),
        );
      },

      // 🟣 КНОПКА ADVICE
      onAdvice: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AnxietyAdvicePage(),
          ),
        );
      },

      // 🔵 (опціонально) КНОПКА RESET
      onReset: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('${topicId}_completedDays');
        await prefs.remove('${topicId}_lastCompletion');
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progress for Anxiety Management has been reset.'),
          ),
        );
      },
    );
  }
}
