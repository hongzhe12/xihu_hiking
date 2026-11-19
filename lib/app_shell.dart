import 'package:flutter/material.dart';

import 'models/hiking_route.dart';
import 'screens/favorites_page.dart';
import 'screens/home_page.dart';
import 'screens/route_detail_page.dart';
import 'state/favorites_controller.dart';
import 'theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.routes,
    required this.favorites,
  });

  final List<HikingRoute> routes;
  final FavoritesController favorites;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  Future<void> _openRoute(HikingRoute route) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RouteDetailPage(
          route: route,
          favorites: widget.favorites,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(
            routes: widget.routes,
            favorites: widget.favorites,
            onOpenRoute: _openRoute,
            onShowFavorites: () => setState(() => _currentIndex = 1),
          ),
          FavoritesPage(
            routes: widget.routes,
            favorites: widget.favorites,
            onOpenRoute: _openRoute,
            onDiscoverRoutes: () => setState(() => _currentIndex = 0),
          ),
        ],
      ),
      bottomNavigationBar: _TrailNavigationBar(
        currentIndex: _currentIndex,
        onSelected: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _TrailNavigationBar extends StatelessWidget {
  const _TrailNavigationBar({
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Row(
                children: [
                  _NavItem(
                    label: '路线',
                    icon: Icons.route_outlined,
                    selectedIcon: Icons.route_rounded,
                    selected: currentIndex == 0,
                    onTap: () => onSelected(0),
                  ),
                  _NavItem(
                    label: '收藏',
                    icon: Icons.bookmark_border_rounded,
                    selectedIcon: Icons.bookmark_rounded,
                    selected: currentIndex == 1,
                    onTap: () => onSelected(1),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.forest : AppColors.muted;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                top: 0,
                left: selected ? 0 : 18,
                right: selected ? 0 : 18,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 2,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.forest : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(selected ? selectedIcon : icon, color: color, size: 21),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: color,
                          fontSize: 11,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
