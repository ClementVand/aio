part of '../aio.dart';

/// Provides access to dependencies integrated in the package.
///
/// You must pass [InitializableDependency] with the desired dependency to
/// the [App.run] method to make it available.
///
/// Example:
/// ```dart
/// App().run(
///   const AppRoot(),
///   dependencies: [
///     InitializableDependency(Prefs()),
///     InitializableDependency.withOptions(AppRouter(), appRoutes),
///   ],
/// );
/// ```
extension DependenciesAccessors on App {
  // TODO Store reference after first access (?) to avoid multiple lookups
  Prefs get prefs => use<Prefs>();

  AppRouter get router => use<AppRouter>();
}
