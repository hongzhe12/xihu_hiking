import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._preferences)
      : _favoriteIds = _preferences.getStringList(_storageKey)?.toSet() ?? {};

  static const _storageKey = 'favorite_route_ids';

  final SharedPreferences _preferences;
  final Set<String> _favoriteIds;

  Set<String> get favoriteIds => Set<String>.unmodifiable(_favoriteIds);

  bool isFavorite(String routeId) => _favoriteIds.contains(routeId);

  int get count => _favoriteIds.length;

  Future<void> toggle(String routeId) async {
    if (!_favoriteIds.remove(routeId)) {
      _favoriteIds.add(routeId);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> add(String routeId) async {
    if (_favoriteIds.add(routeId)) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> remove(String routeId) async {
    if (_favoriteIds.remove(routeId)) {
      notifyListeners();
      await _persist();
    }
  }

  Future<void> _persist() {
    return _preferences.setStringList(_storageKey, _favoriteIds.toList());
  }
}
