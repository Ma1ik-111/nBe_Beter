import 'dart:ui';
import 'package:flutter/material.dart';
import '../mental_health.dart'; // шлях до свого MentalHealthPage

class CongratsPage extends StatelessWidget {
  const CongratsPage({super.key, required this.title});
  final String title; // назва теми (можеш передати будь-що або не показувати)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: const Color.fromARGB(0, 246, 246, 246),
      ),
      body: Stack(
        children: [
          // фон
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0E1730), Color(0xFF0B1325)],
                ),
              ),
            ),
          ),
          // картка
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _CongratsCard(
                title: title,
                onBack: () {
                  // повертаємо користувача до MentalHealthPage
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MentalHealthPage()),
                    (route) => route.isFirst,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CongratsCard extends StatelessWidget {
  const _CongratsCard({required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const radius = 28.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        // градієнтна рамка
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7A3EF4), Color(0xFFFF7E39)],
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: const Color(0x66121C3D), // напівпрозорий «скляний» фон
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🥳', style: TextStyle(fontSize: 70)),
                  const SizedBox(height: 16),
                  const Text(
                    'Awesome work!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "You're one step closer\nto your best self.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.3),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Keep going—consistency\nbeats intensity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.3),
                  ),
                  const Text(
                    'Comeback tomorrow',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22, height: 1.0),
                  ),
                  const SizedBox(height: 24),
                  _GradientButton(
                    label: 'Back to Mental Health',
                    icon: Icons.arrow_forward_rounded,
                    onTap: onBack,
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

class _GradientButton extends StatelessWidget {
  const _GradientButton({required this.label, required this.icon, required this.onTap});
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color.fromARGB(0, 255, 255, 255),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Ink(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF568BFF), Color(0xFF2B4CFF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(color: Color(0x55000000), blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.arrow_right_alt_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Back to Mental Health',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
