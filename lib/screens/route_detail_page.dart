import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/hiking_route.dart';
import '../state/favorites_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/difficulty_badge.dart';
import '../widgets/route_cover.dart';

class RouteDetailPage extends StatelessWidget {
  const RouteDetailPage({
    super.key,
    required this.route,
    required this.favorites,
  });

  final HikingRoute route;
  final FavoritesController favorites;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: AnimatedBuilder(
        animation: favorites,
        builder: (context, _) {
          final isFavorite = favorites.isFavorite(route.id);
          return Scaffold(
            backgroundColor: AppColors.canvas,
            bottomNavigationBar: _FavoriteBar(
              isFavorite: isFavorite,
              onPressed: () => favorites.toggle(route.id),
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _RouteHero(
                        route: route,
                        isFavorite: isFavorite,
                        onToggleFavorite: () => favorites.toggle(route.id),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                DifficultyBadge(difficulty: route.difficulty),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    route.area,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              route.name,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 11),
                            Text(
                              route.summary,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.muted),
                            ),
                            const SizedBox(height: 24),
                            _StatsBand(route: route),
                            const SizedBox(height: 32),
                            const _SectionHeading(
                              eyebrow: 'ABOUT THE TRAIL',
                              title: '路线介绍',
                            ),
                            const SizedBox(height: 12),
                            Text(
                              route.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 32),
                            const _SectionHeading(
                              eyebrow: 'ON THE WAY',
                              title: '路线特点',
                            ),
                            const SizedBox(height: 15),
                            _Highlights(items: route.highlights),
                            const SizedBox(height: 32),
                            _TipPanel(tip: route.tip),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 1,
                                  color: AppColors.moss,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '离线示例路线 · 请以现场标识和安全提示为准',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RouteHero extends StatelessWidget {
  const _RouteHero({
    required this.route,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final HikingRoute route;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final heroHeight = 360 + topPadding;

    return SizedBox(
      height: heroHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RouteCover(
            asset: route.coverAsset,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.35, 0.72, 1],
                colors: [
                  Color(0x8A0B1410),
                  Color(0x120B1410),
                  Color(0x1A0B1410),
                  Color(0x9C0B1410),
                ],
              ),
            ),
          ),
          Positioned(
            top: topPadding + 8,
            left: 8,
            right: 8,
            child: Row(
              children: [
                _HeroButton(
                  tooltip: '返回',
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const Spacer(),
                _HeroButton(
                  tooltip: isFavorite ? '取消收藏' : '收藏路线',
                  icon: isFavorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  iconColor:
                      isFavorite ? const Color(0xFFFFC5AC) : AppColors.surface,
                  onPressed: onToggleFavorite,
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Row(
              children: [
                Text(
                  'WEST LAKE · TRAIL',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.surface.withOpacity(0.74),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.8,
                      ),
                ),
                const Spacer(),
                Text(
                  route.distanceLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.surface,
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

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.iconColor = AppColors.surface,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.ink.withOpacity(0.36),
      shape: const CircleBorder(
        side: BorderSide(color: Color(0x44FFFFFF)),
      ),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, color: iconColor),
      ),
    );
  }
}

class _StatsBand extends StatelessWidget {
  const _StatsBand({required this.route});

  final HikingRoute route;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(Icons.straighten_rounded, '距离', route.distanceLabel),
      _StatData(Icons.trending_up_rounded, '累计爬升', '${route.ascentM} m'),
      _StatData(Icons.schedule_rounded, '预计耗时', route.durationLabel),
      _StatData(Icons.terrain_rounded, '难度', route.difficulty.label),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.line),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < stats.length; index++) ...[
            Expanded(child: _StatItem(data: stats[index])),
            if (index < stats.length - 1)
              Container(
                width: 1,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: AppColors.line,
              ),
          ],
        ],
      ),
    );
  }
}

class _StatData {
  const _StatData(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(data.icon, size: 17, color: AppColors.moss),
        const SizedBox(height: 9),
        Text(
          data.value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 15,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          data.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.clay,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
              ),
        ),
        const SizedBox(height: 5),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class _Highlights extends StatelessWidget {
  const _Highlights({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++)
          Padding(
            padding:
                EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.forest,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}'.padLeft(2, '0'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.surface,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      items[index],
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TipPanel extends StatelessWidget {
  const _TipPanel({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 19),
      decoration: BoxDecoration(
        color: AppColors.mist,
        border: const Border(
          left: BorderSide(color: AppColors.clay, width: 3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 19,
                color: AppColors.clay,
              ),
              const SizedBox(width: 7),
              Text(
                '注意事项',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(tip, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _FavoriteBar extends StatelessWidget {
  const _FavoriteBar({
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: isFavorite
                    ? OutlinedButton.icon(
                        onPressed: onPressed,
                        icon: const Icon(Icons.bookmark_rounded, size: 20),
                        label: const Text('已收藏 · 点按取消'),
                      )
                    : FilledButton.icon(
                        onPressed: onPressed,
                        icon: const Icon(Icons.bookmark_add_outlined, size: 20),
                        label: const Text('收藏这条路线'),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
