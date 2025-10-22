import 'package:flutter/material.dart';

class AnxietyAdvicePage extends StatefulWidget {
  const AnxietyAdvicePage({super.key});

  @override
  State<AnxietyAdvicePage> createState() => _AnxietyAdvicePageState();
}

class _AnxietyAdvicePageState extends State<AnxietyAdvicePage> {
  final _pageCtrl = PageController(viewportFraction: 0.90);
  int _page = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _AdviceCardPage(
        icon: Icons.favorite_outline,
        title: 'Daily tips to ease anxiety',
        subtitle: '',
        items: const [
          (
            'Breathe consciously',
            'Practice deep breathing: inhale for 4, hold for 4, exhale for 4.'
          ),
          (
            'Create a simple routine',
            'Start and end your day with calming rituals like tea or stretching.'
          ),
          (
            'Write it out',
            'Spend 5 minutes journaling your thoughts.'
          ),
          (
            'Avoid overthinking traps',
            'Notice when your mind spirals—redirect gently to something real.'
          ),
          (
            'Stay socially connected',
            'Talk to someone you trust regularly.'
          ),
          (
            'Feeling good – the new Mood therapy',
            'Even short, kind interactions reduce anxiety.'
          ),
          (
            'Be kind to yourself',
            'You’re doing your best. Speak to yourself like a friend.'
          ),
        ],
      ),
      _AdviceCardPage(
        icon: Icons.menu_book_outlined,
        title: 'Helpful literature',
        subtitle: 'Evidence-based books for anxiety management',
        items: const [
          ('The Anxiety and Phobia Workbook', 'Edmund Bourne'),
          ('Dare – The New Way to End Anxiety and Stop Panic Attacks', 'Barry McDonagh'),
          ('Rewire Your Anxious Brain', 'Catherine M. Pittman & Elizabeth M. Karle'),
          ('The Happiness Trap', 'Russ Harris'),
          ('Hope and Help for Your Nerves', 'Dr. Claire Weekes'),
          ('Unwinding Anxiety', 'Dr. Judson Brewer'),
          ('Feeling Good – The New Mood Therapy', 'Dr. David D. Burns'),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ADVICE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: pages.length,
              onPageChanged: (i) => setState(() => _page = i),
              physics: const BouncingScrollPhysics(),
              padEnds: false,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 20 : 10,
                  right: i == pages.length - 1 ? 20 : 10,
                ),
                child: pages[i],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _Dots(count: pages.length, index: _page),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AdviceCardPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<(String, String)> items;

  const _AdviceCardPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16132A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF7C4DFF), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 22),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: const Color(0xFFB388FF), size: 28),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 38, top: 2, bottom: 10),
                    child: Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                const Divider(color: Color(0xFF7C4DFF), thickness: 0.6),
                const SizedBox(height: 10),
                ...items.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _AdviceItem(title: e.$1, desc: e.$2),
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

class _AdviceItem extends StatelessWidget {
  final String title;
  final String desc;

  const _AdviceItem({required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: Color(0xFFB388FF), fontSize: 16)),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.white, height: 1.4),
              children: [
                TextSpan(text: '$title\n', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: desc, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final int index;

  const _Dots({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: active ? 18 : 6,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFB388FF) : const Color(0xFF4E3E8C),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
