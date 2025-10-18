import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'congrats_page.dart';

class DayPlanPage extends StatefulWidget {
  const DayPlanPage({super.key, required this.topicId, required this.title, required this.tasks});

  final String topicId;
  final String title;
  final List<String> tasks;

  static String _todayStr() {
    final d = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  static Future<bool> isCompletedToday(String topicId) async {
    final prefs = await SharedPreferences.getInstance();
    final dates = prefs.getStringList('$topicId:completedDates') ?? const [];
    return dates.contains(_todayStr());
  }

  @override
  State<DayPlanPage> createState() => _DayPlanPageState();
}

class _DayPlanPageState extends State<DayPlanPage> {
  final List<List<Color>> _grads = const [
    [Color(0xFF7A3EF4), Color(0xFFB266FF)],
    [Color(0xFFFF9548), Color(0xFFFF6F00)],
    [Color(0xFF00BFA6), Color(0xFF00E5FF)],
    [Color(0xFFFFD600), Color(0xFFFFC107)],
    [Color(0xFF1976D2), Color(0xFF2962FF)],
    [Color(0xFFE91E63), Color(0xFF9C27B0)],
  ];
  bool _shownCongrats = false; // щоб не пушнути сторінку двічі

  late SharedPreferences _prefs;
  late String _today;
  Set<int> _checked = {}; // індекси виконаних завдань СЬОГОДНІ
  Set<String> _completedDates = {}; // дні, коли виконано УСІ завдання
  int _streak = 0; // днів підряд

  String get _kTasksForToday => '${widget.topicId}:tasks:$_today';
  String get _kCompletedSet => '${widget.topicId}:completedDates';

  void _maybeShowCongrats() {
    final allDone = widget.tasks.isNotEmpty && _checked.length == widget.tasks.length;
    if (allDone && !_shownCongrats && mounted) {
      _shownCongrats = true;
      // показати після поточного кадру
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => CongratsPage(title: widget.title)));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _today = DayPlanPage._todayStr(); // один раз
    _init(); // асинхронно завантажить стан
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    // завдання на сьогодні
    final saved = _prefs.getStringList(_kTasksForToday) ?? const [];
    _checked = saved.map(int.parse).toSet();

    // усі дні з повним виконанням
    _completedDates = (_prefs.getStringList(_kCompletedSet) ?? const []).toSet();

    _recomputeStreak();

    if (!mounted) return;
    setState(() {});
    _maybeShowCongrats(); // <-- переносимо сюди (коли _checked уже відомі)
  }

  void _recomputeStreak() {
    int s = 0;
    DateTime anchor;
    final todayDone = _completedDates.contains(_today);
    if (todayDone) {
      anchor = DateTime.now();
    } else {
      anchor = DateTime.now().subtract(const Duration(days: 1));
      if (!_completedDates.contains(_fmt(anchor))) {
        _streak = 0;
        return;
      }
    }
    while (_completedDates.contains(_fmt(anchor))) {
      s++;
      anchor = anchor.subtract(const Duration(days: 1));
    }
    _streak = s;
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _toggle(int i, bool value) async {
    setState(() {
      value ? _checked.add(i) : _checked.remove(i);
    });

    // зберігаємо «сьогоднішні» чекбокси
    await _prefs.setStringList(_kTasksForToday, _checked.map((e) => '$e').toList());

    // підтримуємо набір «повністю виконаних днів»
    final allDone = widget.tasks.isNotEmpty && _checked.length == widget.tasks.length;
    if (allDone) {
      _completedDates.add(_today);
    } else {
      _completedDates.remove(_today);
    }
    await _prefs.setStringList(_kCompletedSet, _completedDates.toList());

    _recomputeStreak();
    _maybeShowCongrats(); // ⬅️ тут відкриваємо сторінку-вітання, якщо все виконано
  }

  @override
  Widget build(BuildContext context) {
    final double appBarH = kToolbarHeight + 16;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: appBarH,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _GradientText(
              'DAY',
              gradient: LinearGradient(colors: [Color(0xFF7A3EF4), Color(0xFFB266FF)]),
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900, letterSpacing: 1.2),
            ),
            const SizedBox(width: 8),
            Text(
              '$_streak',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: Colors.white70,
              ),
            ),
          ],
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
              padding: const EdgeInsets.fromLTRB(16, 35, 16, 16),
              child: ListView.separated(
                itemCount: widget.tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, i) {
                  final g = _grads[i % _grads.length];
                  final checked = _checked.contains(i);
                  return Row(
                    children: [
                      // великий прямокутник (текст завдання)
                      Expanded(
                        child: _GradientOutlineBox(
                          height: 72,
                          gradient: LinearGradient(colors: g),
                          radius: 16,
                          innerFill: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.tasks[i],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // маленький прямокутник з чекбоксом
                      _GradientOutlineBox(
                        width: 64,
                        height: 64,
                        gradient: LinearGradient(colors: g),
                        radius: 14,
                        innerFill: Colors.transparent,
                        child: Center(
                          child: Checkbox(
                            value: checked,
                            onChanged: (v) => _toggle(i, v ?? false),
                            side: const BorderSide(color: Colors.white70, width: 2),
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                    ],
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

/// ——— допоміжні віджети ———

class _GradientOutlineBox extends StatelessWidget {
  const _GradientOutlineBox({
    required this.height,
    required this.gradient,
    this.width,
    this.radius = 12,
    this.borderWidth = 3,
    this.innerFill = Colors.transparent,
    this.child,
  });

  final double? width;
  final double height;
  final Gradient gradient;
  final double radius;
  final double borderWidth;
  final Color innerFill;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      padding: EdgeInsets.all(borderWidth),
      child: Container(
        decoration: BoxDecoration(
          color: innerFill,
          borderRadius: BorderRadius.circular(radius - borderWidth),
        ),
        child: child,
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText(this.text, {required this.gradient, required this.style, super.key});
  final String text;
  final Gradient gradient;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => gradient.createShader(rect),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
