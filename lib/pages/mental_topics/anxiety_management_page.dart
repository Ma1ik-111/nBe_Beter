import 'package:flutter/material.dart';
import 'topic_detail_scaffold.dart';

class AnxietyManagementPage extends StatelessWidget {
  const AnxietyManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TopicDetailScaffold(
      title: 'Anxiety Management',
      accent: const Color(0xFF8E8E8E),
      bigIcon: Icons.person_outline_rounded,
    );
  }
}
