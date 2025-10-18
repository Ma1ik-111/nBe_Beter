import 'package:flutter/material.dart';

// підстав свої правильні шляхи (у тебе саме такі назви класів)
import 'package:bbeter/pages/mental_health.dart';
import 'package:bbeter/pages/body_health.dart';
import 'package:bbeter/pages/Habits_health.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ФОН
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0D1240), Color(0xFF0A0F28)],
                ),
              ),
            ),
          ),
          // легкі діагональні “лопаті”
          Positioned(right: -120, top: 120, child: _bgBlade(width: 420, height: 280, opacity: .10)),
          Positioned(
            left: -140,
            bottom: 140,
            child: _bgBlade(width: 460, height: 300, opacity: .08),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              children: [
                _HomeTile(
                  title: 'IMPROVE MENTAL HEALTH',
                  accent: const Color(0xFF7A3EF4),
                  icon: Icons.help_outline_rounded,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const MentalHealthPage())),
                ),
                const SizedBox(height: 28),
                _HomeTile(
                  title: 'IMPROVE YOUR BODY',
                  accent: const Color(0xFF00BFA6),
                  icon: Icons.person,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const body_health())),
                ),
                const SizedBox(height: 28),
                _HomeTile(
                  title: 'BREAK BAD HABITS',
                  accent: const Color(0xFFFF9800),
                  icon: Icons.smoke_free,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const HabitsHealth())),
                ),
                const SizedBox(height: 28),
                _HomeTile(
                  title: 'SCHEDULE',
                  accent: const Color(0xFF1976D2),
                  icon: Icons.calendar_month_rounded,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const _ComingSoonPage(title: 'Schedule')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// КАРТКА
class _HomeTile extends StatelessWidget {
  const _HomeTile({required this.title, required this.accent, required this.icon, this.onTap});

  final String title;
  final Color accent;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const radius = 12.0;

    return Center(
      child: SizedBox(
        width: 560,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: Ink(
              height: 118,
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(radius),
                boxShadow: const [
                  BoxShadow(color: Color(0x26000000), blurRadius: 14, offset: Offset(0, 6)),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // верхня смужка
                  Positioned(
                    left: 14,
                    right: 14,
                    top: 10,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  // текст
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  // “флоат”-іконка
                  Positioned(
                    right: -6,
                    top: -16,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Icon(icon, color: accent, size: 32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Діагональні “лопаті” фону
Widget _bgBlade({required double width, required double height, double opacity = .1}) {
  return Transform.rotate(
    angle: -0.6,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(opacity), Colors.white.withOpacity(opacity * .1)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
    ),
  );
}

/// Плейсхолдер
class _ComingSoonPage extends StatelessWidget {
  const _ComingSoonPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: const Center(
        child: Text('Coming soon…', style: TextStyle(color: Colors.white70, fontSize: 18)),
      ),
      backgroundColor: const Color(0xFF0D1240),
    );
  }
}
