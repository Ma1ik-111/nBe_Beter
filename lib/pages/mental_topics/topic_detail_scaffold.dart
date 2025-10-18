import 'dart:ui';
import 'package:flutter/material.dart';

class TopicDetailScaffold extends StatelessWidget {
  const TopicDetailScaffold({
    super.key,
    required this.title,
    required this.accent,
    required this.bigIcon,
    this.onStart,
    this.onAdvice,
    this.onNotification,
    this.onReset,
  });

  final String title;
  final Color accent;
  final IconData bigIcon;
  final VoidCallback? onStart;
  final VoidCallback? onAdvice;
  final VoidCallback? onNotification;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 22,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            height: 3,
            width: 140,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [accent, accent.withOpacity(0.6)]),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Фон (градієнт; якщо хочеш — підстав Image.asset)
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F1A2B), Color(0xFF121E36)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Column(
                children: [
                  // Велика картка-прев’ю
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // «скляний» напівпрозорий фон
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: accent, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(bigIcon, size: 86, color: Colors.white),
                                  const SizedBox(height: 12),
                                  Text(
                                    title.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 32,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // маленька «refresh» іконка у правому верхньому куті (декор)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 3,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: onReset, // ⬅️ ТУТ ВИКЛИКАЄМО
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.refresh, size: 18, color: Colors.deepPurple),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Кнопки
                  _OutlineActionButton(
                    label: 'START',
                    icon: Icons.play_circle_fill_rounded,
                    borderColor: accent,
                    onTap: onStart,
                  ),
                  const SizedBox(height: 12),
                  _OutlineActionButton(
                    label: 'ADVICE',
                    icon: Icons.local_fire_department_rounded,
                    borderColor: const Color(0xFFFF9548),
                    onTap: onAdvice,
                  ),
                  const SizedBox(height: 12),
                  _OutlineActionButton(
                    label: 'NOTIFICATION',
                    icon: Icons.access_time_filled_rounded,
                    borderColor: const Color(0xFF1976D2),
                    onTap: onNotification,
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

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.label,
    required this.icon,
    required this.borderColor,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const radius = 14.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor, width: 3),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
