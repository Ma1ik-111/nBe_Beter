import 'package:flutter/material.dart';

class AccentCard extends StatelessWidget {
  const AccentCard({
    super.key,
    required this.title,
    required this.gradientColors,
    required this.icon,
    required this.iconColor,
    this.width = 250,
    this.height = 125,
    this.background = const Color(0xFF33332E),
    this.onTap,
    this.titleStyle,
  });

  final String title;
  final List<Color> gradientColors;
  final IconData icon;
  final Color iconColor;
  final double width;
  final double height;
  final Color background;
  final VoidCallback? onTap;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12);
    final defaultStyle =
        (Theme.of(context).textTheme.titleMedium ??
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))
            .copyWith(color: Colors.white, letterSpacing: 1.0);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: radius,
                  child: Container(
                    color: background,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // верхня смужка
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        // контент
                        Expanded(
                          child: Center(
                            child: Text(
                              title,

                              textAlign: TextAlign.center,
                              style: defaultStyle.merge(titleStyle),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // іконка, що «випирає»
                Positioned(
                  top: -10,
                  right: -10,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          offset: Offset(0, 2),
                          color: Color(0x33000000),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 32, color: iconColor),
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
