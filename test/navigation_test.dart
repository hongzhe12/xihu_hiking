import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xihu_hiking/data/route_repository.dart';
import 'package:xihu_hiking/main.dart';
import 'package:xihu_hiking/state/favorites_controller.dart';

void main() {
  testWidgets('tapping a route card opens its detail page', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final routes = await const RouteRepository().loadRoutes();
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      XihuHikingApp(
        routes: routes,
        favorites: FavoritesController(preferences),
      ),
    );
    await tester.pumpAndSettle();

    final routeTitle = find.text('宝石山环线');
    await tester.scrollUntilVisible(
      routeTitle,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(routeTitle);
    await tester.pumpAndSettle();

    expect(find.text('路线介绍'), findsOneWidget);
    expect(find.text('收藏这条路线'), findsOneWidget);
    expect(
      tester.getSize(find.byType(SingleChildScrollView)).height,
      greaterThan(0),
    );
  });
}
