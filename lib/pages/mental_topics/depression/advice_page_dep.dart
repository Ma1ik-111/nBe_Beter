import 'dart:ui';
import 'package:flutter/material.dart';

class AdvicePage extends StatefulWidget {
  const AdvicePage({super.key, required this.accent});
  final Color accent;

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
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
      final fraction = (w - gap) / w;

      // перевидаємо контролер під нову ширину
      _controller?.dispose();
      _controller = PageController(viewportFraction: fraction, initialPage: _index);
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // ← було _controller.dispose();
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
                      padEnds: false,
                      controller: _controller!,
                      onPageChanged: (i) => setState(() => _index = i),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _AdviceCard(
                            borderGradient: LinearGradient(
                              colors: [accent, accent.withOpacity(0.6)],
                            ),
                            leading: _CircleIcon(icon: Icons.menu_book_rounded, color: accent),
                            title: 'Helpful literature',
                            subtitle: 'Evidence-based books for easing depression',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _Bullet('The Happiness Trap — Russ Harris'),
                                _Bullet('Mind Over Mood — Dennis Greenberger & Christine Padesky'),
                                _Bullet('Feeling Good — David D. Burns'),
                                _Bullet(
                                  'The Mindful Way Through Depression — Williams, Teasdale, Segal & Kabat-Zinn',
                                ),
                                _Bullet('Lost Connections — Johann Hari'),
                                _Bullet('Radical Acceptance — Tara Brach'),
                                _Bullet('Reasons to Stay Alive — Matt Haig'),
                                SizedBox(height: 16),
                                Text(
                                  'Books can support but do not replace professional help.',
                                  style: TextStyle(color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: _AdviceCard(
                            borderGradient: const LinearGradient(
                              colors: [Color(0xFF7A3EF4), Color(0xFFFF7E39)],
                            ),
                            leading: const _CircleIcon(
                              icon: Icons.favorite_rounded,
                              color: Color(0xFF7A3EF4),
                            ),
                            title: 'Things that really help',
                            subtitle: 'when getting out of depression',
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                _Bullet.rich(
                                  bold: 'Sleep is sacred.',
                                  rest:
                                      ' Go to bed and wake up at the same time. Even if you can’t sleep — lie down without the phone.',
                                ),
                                _Bullet.rich(
                                  bold: 'Move your body.',
                                  rest:
                                      ' 10 minutes of walking or stretching already changes your chemistry.',
                                ),
                                _Bullet.rich(
                                  bold: 'Food is fuel.',
                                  rest: ' Eat 2–3× a day; add protein (eggs, chicken, beans).',
                                ),
                                _Bullet.rich(
                                  bold: 'Light and fresh air.',
                                  rest: ' Go outside for 5–10 minutes—like vitamins for the brain.',
                                ),
                                _Bullet.rich(
                                  bold: 'Small tasks.',
                                  rest:
                                      ' Make the bed, wash a cup, short errand—tiny wins return a sense of control.',
                                ),
                                _Bullet.rich(
                                  bold: 'Breathing & pauses.',
                                  rest:
                                      ' Try “box breathing”: 4 in, hold 4, 4 out, hold 4 — 5 times.',
                                ),
                                _Bullet.rich(
                                  bold: 'Less social media.',
                                  rest: ' At least one hour a day offline.',
                                ),
                                _Bullet.rich(
                                  bold: 'One pleasant thing daily.',
                                  rest: ' Movie, bath, tea, music, drawing, reading.',
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

// ---------------- widgets ----------------

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
    final bullet = Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(top: 10),
      decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
    );

    Widget line;
    if (text != null) {
      line = Text(text!, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.35));
    } else {
      line = RichText(
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
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bullet,
          const SizedBox(width: 10),
          Expanded(child: line),
        ],
      ),
    );
  }
}
