import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/hiking_route.dart';
import '../state/favorites_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/route_card.dart';
import '../widgets/route_cover.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.routes,
    required this.favorites,
    required this.onOpenRoute,
    required this.onDiscoverRoutes,
  });

  final List<HikingRoute> routes;
  final FavoritesController favorites;
  final ValueChanged<HikingRoute> onOpenRoute;
  final VoidCallback onDiscoverRoutes;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: AnimatedBuilder(
        animation: favorites,
        builder: (context, _) {
          final favoriteRoutes = routes
              .where((route) => favorites.isFavorite(route.id))
              .toList(growable: false);

          return SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      sliver: SliverToBoxAdapter(
                        child: _Header(
                          count: favoriteRoutes.length,
                          onDiscoverRoutes: onDiscoverRoutes,
                        ),
                      ),
                    ),
                    if (favoriteRoutes.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _EmptyFavorites(
                          onDiscoverRoutes: onDiscoverRoutes,
                        ),
                      )
                    else ...[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                        sliver: SliverList.separated(
                          itemCount: favoriteRoutes.length,
                          itemBuilder: (context, index) {
                            final route = favoriteRoutes[index];
                            return RouteCard(
                              key: ValueKey('favorite-${route.id}'),
                              route: route,
                              isFavorite: true,
                              onTap: () => onOpenRoute(route),
                              onFavoritePressed: () {
                                final messenger = ScaffoldMessenger.of(context);
                                messenger.hideCurrentSnackBar();
                                favorites.remove(route.id);
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('已取消收藏「${route.name}」'),
                                    action: SnackBarAction(
                                      label: '撤销',
                                      onPressed: () => favorites.add(route.id),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 18),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            '收藏保存在本机 · 再次出发前请确认天气与开放信息',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.count,
    required this.onDiscoverRoutes,
  });

  final int count;
  final VoidCallback onDiscoverRoutes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'YOUR TRAIL SHELF',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.clay,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.8,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onDiscoverRoutes,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.forest,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('发现路线'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                '我的收藏',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                '$count 条',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 9),
        Text(
          count == 0 ? '想走的山路，先留在这里。' : '把下一次出发，留给真正想走的路线。',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites({required this.onDiscoverRoutes});

  final VoidCallback onDiscoverRoutes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 210,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const RouteCover(
                    asset: 'assets/images/yunqi.jpg',
                    alignment: Alignment(0, -0.15),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x190C1713), Color(0xB30C1713)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.bookmark_border_rounded,
                          color: AppColors.surface,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '还没有收藏路线',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: AppColors.surface,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '在路线列表或详情页点按书签，收藏会保存在本机。',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onDiscoverRoutes,
              icon: const Icon(Icons.route_rounded, size: 19),
              label: const Text('去发现路线'),
            ),
          ),
        ],
      ),
    );
  }
}
