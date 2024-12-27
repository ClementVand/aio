part of '../aio.dart';

/// Allowed keys for the shared preferences.
///
/// EASY SEARCH: :Prefs:
// TODO: Separate the internal keys from the user keys.
enum SPKeys {
  onBoardingPageIndex,
  onboardingCompleted,

  /// Core app preferences.
  _locale,
}

enum SPKeysTest {
  test,
}

/// A class to manage the app preferences.
class Prefs extends Dependency<Prefs> {
  late final SharedPreferencesWithCache _prefsWithCache;

  @override
  Future<void> init(Object? options) async {
    _prefsWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: _allowedKeys,
      ),
    );
    return super.init(options);
  }

  /// Get the instance of the [SharedPreferencesWithCache].
  ///
  /// We use [I] instead of "instance" to simplify the usage.
  /// We also ensure that the shared preferences is initialized before using it.
  SharedPreferencesWithCache get I {
    _requiresInitialization;
    return _prefsWithCache;
  }
}

/// A [Set] of allowed keys for the shared preferences.
/// Converted from [SPKeys].
///
/// This is used to prevent the app from using any key that is not allowed.
final Set<String> _allowedKeys = SPKeys.values
    .map(
      (e) => e.toString(),
    )
    .toSet();

// @formatter:off
/// An extension to access the shared preferences with allowed keys [SPKeys].
extension PrefsAccess on Prefs {
  /// Overridden methods from [SharedPreferencesWithCache].
  /// This is used to provide a better API for the shared preferences by
  /// using [SPKeys] instead of [String].
  dynamic get(SPKeys key) => I.get(key.toString());
  String? getString(SPKeys key) => I.getString(key.toString());
  bool? getBool(SPKeys key) => I.getBool(key.toString());
  int? getInt(SPKeys key) => I.getInt(key.toString());
  double? getDouble(SPKeys key) => I.getDouble(key.toString());
  List<String>? getStringList(SPKeys key) => I.getStringList(key.toString());

  Future<void> setString(SPKeys key, String value) => I.setString(key.toString(), value);
  Future<void> setBool(SPKeys key, bool value) => I.setBool(key.toString(), value);
  Future<void> setInt(SPKeys key, int value) => I.setInt(key.toString(), value);
  Future<void> setDouble(SPKeys key, double value) => I.setDouble(key.toString(), value);
  Future<void> setStringList(SPKeys key, List<String> value) => I.setStringList(key.toString(), value);

  bool exists(SPKeys key) => I.containsKey(key.toString());
  Future<void> remove(SPKeys key) => I.remove(key.toString());
  Future<void> clear() => I.clear();

  /// Custom methods for custom objects.
  // TODO: Add custom methods here.

  /// Clear all the [SPKeys] from the shared preferences.
  /// We don't clear all the preferences to prevent any unwanted data loss from
  /// other packages that use shared preferences.
  ///
  /// See [SharedPreferencesWithCache.clear] if you want to clear all the preferences.
  Future<void> clearAppPrefs() async {
    for (SPKeys key in SPKeys.values) {
      await remove(key);
    }
  }
}
// @formatter:on
