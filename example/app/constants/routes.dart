import 'package:aio/aio.dart';
import 'package:flutter/material.dart';

import '../views/main/main_view.dart';
import '../views/main/pages/home_view.dart';

/// A helper method to wrap the child with a [Material] widget.
Widget _material(Widget child) => Material(
      color: Colors.transparent,
      child: child,
    );

/// App navigation routes.
/// The routes can be accessed through deep-linking.
///
/// EASY SEARCH: :Router:
final List<RouteBase> appRoutes = [
  GoRoute(
    path: Routes.authentication,
    builder: (context, state) => _material(const PagePlaceholder(label: "Authentication")),
  ),
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) => MainView(navigationShell: navigationShell),
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) => _material(const HomeView()),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.settings,
            builder: (context, state) => _material(const PagePlaceholder(label: "Settings")),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: Routes.logs,
            builder: (context, state) => _material(const LoggerView()),
          ),
        ],
      ),
    ],
    redirect: (context, state) async {
      final bool userIsLogged = App().session.isLogged;

      if (!userIsLogged) return Routes.authentication;

      return null;
    },
  ),
];

/// An data class to manage the app routes.
///
/// EASY SEARCH: :Routes:
class Routes {
  Routes._();

  static const String authentication = "/authentication";

  static const String home = "/home";
  static const String settings = "/settings";
  static const String logs = "/logs";
}
