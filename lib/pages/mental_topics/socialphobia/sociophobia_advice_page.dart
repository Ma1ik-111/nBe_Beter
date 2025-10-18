import 'dart:ui';
import 'package:flutter/material.dart';

class SociophobiaAdvicePage extends StatefulWidget {
  const SociophobiaAdvicePage({super.key, required this.accent});
  final Color accent;

  @override
  State<SociophobiaAdvicePage> createState() => _SociophobiaAdvicePageState();
}

class _SociophobiaAdvicePageState extends State<SociophobiaAdvicePage> {
  PageController? _controller;
  int _index = 0;
  double? _lastWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final w = MediaQuery.of(context).size.width;
    if (_lastWidth != w) {
      _lastWidth = w;
      const gap = 16.0;
      final fraction = (w - gap) / w; // відстань між картками = 16
      _controller?.dispose();
      _controller = PageController(viewportFraction: fraction, initialPage: _index);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'ADVICE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.1),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
            height: 3,
            width: 120,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [accent, accent.withOpacity(0.6)]),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
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
              padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 24, 16, 16),
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _controller!,
                      padEnds: false,
                      onPageChanged: (i) => setState(() => _index = i),
                      children: [
                        // ---------- Card #1: Literature ----------
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _AdviceCard(
                            borderGradient: LinearGradient(
                              colors: [accent, accent.withOpacity(0.55)],
                            ),
                            leading: _CircleIcon(icon: Icons.menu_book_rounded, color: accent),
                            title: 'Helpful literature',
                            subtitle: 'Evidence-based books for easing sociophobia',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _Bullet(
                                  'The Shyness & Social Anxiety Workbook — Martin Antony & Richard Swinson',
                                ),
                                _Bullet('Overcoming Social Anxiety and Shyness — Gillian Butler'),
                                _Bullet('How to Be Yourself — Ellen Hendriksen'),
                                _Bullet('The Confidence Gap — Russ Harris'),
                                _Bullet('The Anxiety and Phobia Workbook — Edmund J. Bourne'),
                                _Bullet('Quiet — Susan Cain'),
                                SizedBox(height: 16),
                                Text(
                                  'Books can support but do not replace professional help.',
                                  style: TextStyle(color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ---------- Card #2: Daily tips ----------
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _AdviceCard(
                            borderGradient: const LinearGradient(
                              colors: [Color(0xFFFFC107), Color(0xFFFF9E80)], // жовтий → теплий
                            ),
                            leading: const _CircleIcon(
                              icon: Icons.favorite_rounded,
                              color: Color(0xFFFFC107),
                            ),
                            title: 'Daily tips to ease',
                            subtitle: 'sociophobia',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _Bullet.rich(
                                  bold: 'Start small\n',
                                  rest:
                                      'Begin with tiny interactions: greet a cashier, ask a short question. Small wins build confidence.',
                                ),
                                _Bullet.rich(
                                  bold: 'Practice calm breathing\n',
                                  rest:
                                      'Try 4–2–6 breathing: inhale 4 sec, hold 2, exhale 6. Helps calm body and mind.',
                                ),
                                _Bullet.rich(
                                  bold: 'Challenge negative thoughts\n',
                                  rest:
                                      'Notice self-critical thoughts and replace with supportive ones: “I’m nervous, but I’m trying.”',
                                ),
                                _Bullet.rich(
                                  bold: 'Join safe environments\n',
                                  rest:
                                      'Find small groups with shared interests (sports, hobbies). Easier to connect when topics are common.',
                                ),
                                _Bullet.rich(
                                  bold: 'Reflect daily\n',
                                  rest:
                                      'Write down 1 social success each day, even small ones. Builds a sense of progress.',
                                ),
                                _Bullet.rich(
                                  bold: 'Limit avoidance\n',
                                  rest:
                                      'Don’t let fear decide everything. Take one small step outside the comfort zone daily.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // індикатори сторінок
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? Colors.white : Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
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

// ---------- Reusable widgets (локальні) ----------
class _AdviceCard extends StatelessWidget {
  const _AdviceCard({
    required this.borderGradient,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.content,
  });

  final Gradient borderGradient;
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    const radius = 22.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        decoration: BoxDecoration(gradient: borderGradient),
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              color: const Color(0x33121C3D),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      leading,
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: content,
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

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({required this.icon, required this.color});
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.15),
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text, {super.key}) : bold = null, rest = null;
  const _Bullet.rich({required this.bold, required this.rest, super.key}) : text = null;

  final String? text;
  final String? bold;
  final String? rest;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
    );

    final Widget line = (text != null)
        ? Text(text!, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.35))
        : RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.35),
              children: [
                TextSpan(
                  text: bold!,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: rest!),
              ],
            ),
          );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dot,
          const SizedBox(width: 10),
          Expanded(child: line),
        ],
      ),
    );
  }
}
