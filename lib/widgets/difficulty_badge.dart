import 'package:flutter/material.dart';

import '../models/hiking_route.dart';

class DifficultyBadge extends StatelessWidget {
  const DifficultyBadge({
    super.key,
    required this.difficulty,
    this.compact = false,
  });

  final RouteDifficulty difficulty;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = switch (difficulty) {
      RouteDifficulty.easy => (
          const Color(0xFFE2EBDD),
          const Color(0xFF315C45),
        ),
      RouteDifficulty.moderate => (
          const Color(0xFFF2E4C6),
          const Color(0xFF7B4C12),
        ),
      RouteDifficulty.hard => (
          const Color(0xFFF2DCD3),
          const Color(0xFF8E3C27),
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 11,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            difficulty.label,
            style: TextStyle(
              color: foreground,
              fontSize: compact ? 12 : 13,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
