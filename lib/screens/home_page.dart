import 'package:flutter/material.dart';

import '../models/hiking_route.dart';
import '../state/favorites_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/route_card.dart';
import '../widgets/route_cover.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.routes,
    required this.favorites,
    required this.onOpenRoute,
    required this.onShowFavorites,
  });

  final List<HikingRoute> routes;
  final FavoritesController favorites;
  final ValueChanged<HikingRoute> onOpenRoute;
  final VoidCallback onShowFavorites;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  RouteDifficulty? _selectedDifficulty;
  String _query = '';

  List<HikingRoute> get _visibleRoutes {
    final query = _query.trim().toLowerCase();
    return widget.routes.where((route) {
      final matchesDifficulty = _selectedDifficulty == null ||
          route.difficulty == _selectedDifficulty;
      final searchable = [
        route.name,
        route.area,
        route.summary,
        ...route.highlights,
      ].join(' ').toLowerCase();
      final matchesQuery = query.isEmpty || searchable.contains(query);
      return matchesDifficulty && matchesQuery;
    }).toList(growable: false);
  }

  bool get _hasActiveFilter =>
      _selectedDifficulty != null || _query.trim().isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _query = '';
      _selectedDifficulty = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleRoutes = _visibleRoutes;

    return AnimatedBuilder(
      animation: widget.favorites,
      builder: (context, _) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: _HomeHero(
                    routeCount: widget.routes.length,
                    favoriteCount: widget.favorites.count,
                    onShowFavorites: widget.onShowFavorites,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _SearchField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      onClear: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _DifficultyFilters(
                      selectedDifficulty: _selectedDifficulty,
                      onSelected: (difficulty) {
                        setState(() => _selectedDifficulty = difficulty);
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CURATED TRAILS',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.clay,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.8,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _hasActiveFilter ? '搜索结果' : '山野路线',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${visibleRoutes.length} 条',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                if (visibleRoutes.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: _NoRoutes(onReset: _clearFilters),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    sliver: SliverList.separated(
                      itemCount: visibleRoutes.length,
                      itemBuilder: (context, index) {
                        final route = visibleRoutes[index];
                        return RouteCard(
                          key: ValueKey(route.id),
                          route: route,
                          isFavorite: widget.favorites.isFavorite(route.id),
                          onTap: () => widget.onOpenRoute(route),
                          onFavoritePressed: () {
                            widget.favorites.toggle(route.id);
                          },
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      '本地示例路线 · 出行请结合天气与现场标识判断\n封面图片来源 Unsplash',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 11, height: 1.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({
    required this.routeCount,
    required this.favoriteCount,
    required this.onShowFavorites,
  });

  final int routeCount;
  final int favoriteCount;
  final VoidCallback onShowFavorites;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
    final height = 414 + (textScale - 1).clamp(0.0, 1.0) * 90;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const RouteCover(
            asset: 'assets/images/lake-hero.jpg',
            alignment: Alignment(0, -0.15),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.34, 1],
                colors: [
                  Color(0x8F0D1814),
                  Color(0x24101814),
                  Color(0xE3121C18),
                ],
              ),
            ),
          ),
          Positioned(
            top: topPadding + 14,
            left: 20,
            right: 18,
            child: _HeroBrandRow(
              favoriteCount: favoriteCount,
              onShowFavorites: onShowFavorites,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 29,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '杭州 · 西湖群山',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFE8EEE7),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.2,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  '走进西湖的山野',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.surface,
                        fontSize: 36,
                        height: 1.12,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 1,
                      color: AppColors.surface.withOpacity(0.56),
                    ),
                    const SizedBox(width: 9),
                    Flexible(
                      child: Text(
                        '$routeCount 条精选路线，从湖岸走到茶山',
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFE2E9E2),
                              fontSize: 13,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBrandRow extends StatelessWidget {
  const _HeroBrandRow({
    required this.favoriteCount,
    required this.onShowFavorites,
  });

  final int favoriteCount;
  final VoidCallback onShowFavorites;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.14),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface.withOpacity(0.28)),
          ),
          child: const Icon(
            Icons.landscape_rounded,
            color: AppColors.surface,
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '西湖徒步',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.surface,
                      fontSize: 19,
                      letterSpacing: 0.8,
                    ),
              ),
              Text(
                'WEST LAKE HIKING',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.surface.withOpacity(0.68),
                      fontSize: 8,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        Semantics(
          button: true,
          label: '打开我的收藏，共 $favoriteCount 条',
          child: Material(
            color: AppColors.ink.withOpacity(0.34),
            shape: const StadiumBorder(
              side: BorderSide(color: Color(0x55FFFFFF)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onShowFavorites,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bookmark_border_rounded,
                      color: AppColors.surface,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$favoriteCount',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: AppColors.surface,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: '搜索路线、山径或地点',
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.pine,
          size: 21,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              onPressed: onClear,
              tooltip: '清除搜索',
              icon: const Icon(Icons.close_rounded, size: 19),
            );
          },
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.pine, width: 1.4),
        ),
      ),
    );
  }
}

class _DifficultyFilters extends StatelessWidget {
  const _DifficultyFilters({
    required this.selectedDifficulty,
    required this.onSelected,
  });

  final RouteDifficulty? selectedDifficulty;
  final ValueChanged<RouteDifficulty?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _FilterItem(
          label: '全部',
          selected: selectedDifficulty == null,
          onTap: () => onSelected(null),
        ),
        for (final difficulty in RouteDifficulty.values)
          _FilterItem(
            label: difficulty.label,
            selected: selectedDifficulty == difficulty,
            onTap: () => onSelected(difficulty),
          ),
      ],
    );
  }
}

class _FilterItem extends StatelessWidget {
  const _FilterItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: '$label难度筛选',
        child: InkWell(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 46),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? AppColors.forest : AppColors.line,
                  width: selected ? 2 : 1,
                ),
              ),
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? AppColors.forest : AppColors.muted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoRoutes extends StatelessWidget {
  const _NoRoutes({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          const Icon(Icons.forest_outlined, size: 34, color: AppColors.moss),
          const SizedBox(height: 12),
          Text(
            '没有找到匹配路线',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '换个关键词，或查看全部难度。',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: onReset, child: const Text('清除筛选')),
        ],
      ),
    );
  }
}
