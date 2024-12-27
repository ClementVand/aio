part of '../aio.dart';

/// A class to manage the app router.
///
/// The router is initialized with a list of [RouteBase].
/// The default route is "/home".
class AppRouter extends Dependency<AppRouter> {
  static const defaultRoute = "/home";
  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeTabNavigatorKey = GlobalKey<NavigatorState>();

  late final GoRouter _router;

  /// [options] must be a list of [RouteBase].
  @override
  Future<void> init(Object? options) {
    if (options == null) throw DependencyError(DependencyErrorType.needsOptions);
    if (options is! List<RouteBase>) throw DependencyError(DependencyErrorType.wrongArguments);

    _router = GoRouter(
      navigatorKey: parentNavigatorKey,
      initialLocation: defaultRoute,
      debugLogDiagnostics: App().debug,
      routes: options,
    );

    return super.init(options);
  }

  /// Get the instance of the [GoRouter].
  ///
  /// We use [I] instead of "instance" to simplify the usage.
  /// We also ensure that the router is initialized before using it.
  GoRouter get I {
    _requiresInitialization;
    return _router;
  }
}
