import 'package:flutter/material.dart';

import '../models/hiking_route.dart';
import '../theme/app_theme.dart';
import 'difficulty_badge.dart';
import 'route_cover.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({
    super.key,
    required this.route,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoritePressed,
  });

  final HikingRoute route;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: AppColors.line.withOpacity(0.82)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.58,
                  child: RouteCover(asset: route.coverAsset),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.46, 1],
                          colors: [
                            Colors.transparent,
                            AppColors.ink.withOpacity(0.72),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 13,
                  right: 64,
                  child: Row(
                    children: [
                      DifficultyBadge(
                        difficulty: route.difficulty,
                        compact: true,
                      ),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          route.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.surface,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: AppColors.ink.withOpacity(0.46),
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: IconButton(
                      onPressed: onFavoritePressed,
                      tooltip:
                          isFavorite ? '取消收藏${route.name}' : '收藏${route.name}',
                      icon: Icon(
                        isFavorite
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isFavorite
                            ? const Color(0xFFFFC5AC)
                            : AppColors.surface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    route.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 15, 14, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 13,
                      runSpacing: 7,
                      children: [
                        _RouteMetric(
                          icon: Icons.straighten_rounded,
                          label: route.distanceLabel,
                        ),
                        _RouteMetric(
                          icon: Icons.schedule_rounded,
                          label: route.durationLabel,
                        ),
                        _RouteMetric(
                          icon: Icons.trending_up_rounded,
                          label: '${route.ascentM} m',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_outward_rounded,
                    size: 18,
                    color: AppColors.forest,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.moss),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.ink,
                fontSize: 12,
                height: 1.2,
              ),
        ),
      ],
    );
  }
}
