import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_shell.dart';
import 'data/route_repository.dart';
import 'models/hiking_route.dart';
import 'state/favorites_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final routes = await const RouteRepository().loadRoutes();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    XihuHikingApp(
      routes: routes,
      favorites: FavoritesController(preferences),
    ),
  );
}

class XihuHikingApp extends StatelessWidget {
  const XihuHikingApp({
    super.key,
    required this.routes,
    required this.favorites,
  });

  final List<HikingRoute> routes;
  final FavoritesController favorites;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '西湖徒步',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: AppShell(routes: routes, favorites: favorites),
    );
  }
}
