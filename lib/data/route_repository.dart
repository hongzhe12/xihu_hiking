import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/hiking_route.dart';

class RouteRepository {
  const RouteRepository({AssetBundle? bundle}) : _bundle = bundle;

  final AssetBundle? _bundle;

  Future<List<HikingRoute>> loadRoutes() async {
    final rawJson =
        await (_bundle ?? rootBundle).loadString('assets/data/routes.json');
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .map((item) => HikingRoute.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }
}
