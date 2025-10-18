import 'package:flutter/material.dart';
import 'package:bbeter/pages/mental_topics/depression_prevention_page.dart';
import 'package:bbeter/pages/mental_topics/emotional_burnout_page.dart';
import 'package:bbeter/pages/mental_topics/stress_reduction_page.dart';
import 'package:bbeter/pages/mental_topics/anxiety_management_page.dart';
import 'package:bbeter/pages/mental_topics/sociophobia_page.dart';
import 'package:bbeter/pages/mental_topics/adhd.dart';

// ------------------- WIDGET -------------------
class _OutlineTile extends StatelessWidget {
  const _OutlineTile({
    required this.title,
    required this.icon,
    required this.borderColor,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const radius = 16.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent, // фон прозорий
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor, width: 3),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 58, color: Colors.white), // ← реальна іконка
                const SizedBox(height: 12),
                Text(
                  // ← реальний текст
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    letterSpacing: 0.5,
                    shadows: [Shadow(blurRadius: 3, color: Colors.black54, offset: Offset(0, 1))],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MentalHealthPage extends StatelessWidget {
  const MentalHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Дані для гріда: [назва, шлях до картинки]
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 214, 0, 0),
        elevation: 0,
        scrolledUnderElevation: 0, // ⬅️ щоб при скролі не з’являвся світлий фон
        surfaceTintColor: Colors.transparent,
        centerTitle: true, // ⬅️ заголовок по центру
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(), // ⬅️ кнопка «назад»
          tooltip: 'Back',
        ),
        title: const Text(
          'MENTAL HEALTH',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.1),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.volume_up_rounded, color: Colors.white70),
          ),
          const SizedBox(width: 4),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.asset(
                'assets/language/gb.png',
                width: 28,
                height: 18,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            height: 3,
            width: 140,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF6F00FF), Color(0xFF9C27FF)]),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // якщо є фон-картинка — лишай
          Positioned.fill(
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.2, -0.3), // зміщення центру
                  radius: 0.85, // 0..1 ≈ відносно меншої сторони
                  colors: [Color.fromARGB(255, 22, 23, 101), Color.fromARGB(255, 29, 29, 56)],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.05,
                children: [
                  _OutlineTile(
                    title: 'DEPRESSION\nPREVENTION',
                    icon: Icons.sentiment_dissatisfied_rounded,
                    borderColor: const Color(0xFF7A3EF4), // фіолет
                    onTap: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const DepressionPreventionPage())),
                  ),
                  _OutlineTile(
                    title: 'EMOTIONAL\nBURNOUT',
                    icon: Icons.local_fire_department_rounded,
                    borderColor: const Color(0xFFFF9548),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => const EmotionalBurnoutPage()));
                    },
                  ),
                  _OutlineTile(
                    title: 'STRESS\nREDUCTION',
                    icon: Icons.bolt_rounded,
                    borderColor: const Color(0xFF00BFA6), // бірюза
                    onTap: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const StressReductionPage())),
                  ),
                  _OutlineTile(
                    title: 'ANXIETY\nMANAGEMENT',
                    icon: Icons.person_outline_rounded,
                    borderColor: const Color(0xFF8E8E8E), // сірий кант як на рефі
                    onTap: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const AnxietyManagementPage())),
                  ),
                  _OutlineTile(
                    title: 'SOCIOPHOBIA',
                    icon: Icons.group_outlined,
                    borderColor: const Color(0xFFFFC107), // жовтий
                    onTap: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const SociophobiaPage())),
                  ),
                  _OutlineTile(
                    title: 'ADHD',
                    icon: Icons.radio_button_checked,
                    borderColor: const Color(0xFF1976D2), // синій
                    onTap: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const AdhdPage())),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
