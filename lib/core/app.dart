part of '../aio.dart';

/// The main class to run the app
///
/// This class is a singleton class that is used to run the app
/// and initialize any required objects.
///
/// To run the app, call the [run] method with the app widget.
///
/// See also:
/// - [DependenciesAccessors] for accessing dependencies integrated in the package.
class App {
  App._();

  static App? _instance;
  static bool _initialized = false;

  factory App() {
    _instance ??= App._();
    return _instance!;
  }

  /// Whether the app has debug mode enabled.
  bool debug = false;

  /// List of dependencies
  final List<Dependency> _dependencies = [];

  /// Runs the app with the given widget.
  ///
  /// [dependencies] is a list of objects that require initialization
  /// before the app can be run.
  /// These objects should implement the [Initializable] class.
  /// The [init] method of each object will be called once before the app is run.
  ///
  /// Available [Dependency]s integrated in the package:
  /// - [Prefs]
  /// - [AppRouter]
  ///
  /// [App] variables:
  /// - [debug] (bool): Whether the app has debug mode enabled.
  /// - [locale] (Locale): The locale of the app.
  ///
  /// Only available if the dependency is specified in the [dependencies] list:
  /// - [prefs] (SharedPreferencesWithCache): The preferences of the app.
  /// - [router] (AppRouter): The router of the app.
  void run(
    Widget app, {
    List<InitializableDependency> dependencies = const [],
    AppLifeCycleHandler? appLifeCycleHandler,
    bool useAppSession = false,
    Widget? errorWidget,
    bool debug = false,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    if (debug) {
      debug = true;
      Logger.enabled = true;
      Logger.clearLogs();
    }

    // TODO: Handle inits somewhere else
    // TODO: Create extension interface or inherits from Dependency to simplify initialization
    appLifeCycleHandler?.init(null);
    if (useAppSession) await _initSession();

    // Initialize dependencies
    try {
      await _initDependencies(dependencies);
    } catch (e) {
      String error = "Error initializing dependencies: $e";
      runApp(errorWidget ??
          ErrorWidget(
            "$error\n\nPlease provide you own error widget (through the `errorWidget` parameter of `App.run()`) to handle errors as you wish.",
          ));
      throw AppRunnerError(error);
    }

    runApp(app);
  }

  /// Gets a dependency of the given type [T].
  /// If the dependency is not found, returns `null`.
  ///
  /// If the dependency is not initialized, it will not be returned.
  T use<T extends Initializable>() {
    // TODO: Test between List and Set/Map for performance
    for (Initializable dependency in _dependencies) {
      if (dependency is T) return dependency;
    }

    throw AppRunnerError("No dependency of type $T found.");
  }

  /// Initializes the dependencies with the given options.
  Future<void> _initDependencies(List<InitializableDependency> dependencies) async {
    for (InitializableDependency dependency in dependencies) {
      // Search for dependency of the same type
      for (Initializable existingDependency in _dependencies) {
        if (existingDependency.runtimeType == dependency.initializableDependency.runtimeType) {
          throw "${dependency.initializableDependency.runtimeType} dependency already exists.";
        }
      }

      await dependency.initializableDependency.init(dependency.options);

      if (!dependency.initializableDependency._initialized && dependency.mandatory) {
        throw "${dependency.initializableDependency.runtimeType} dependency was not initialized.";
      }
      _dependencies.add(dependency.initializableDependency);
    }
    _initialized = true;
  }

  /// Throws an error if the app has not been initialized.
  // TODO: Remove ?
  void get _requiresInitialization {
    if (_initialized) return;
    throw AppRunnerError("App has not been initialized. Call the run method before using any other methods.");
  }
}

class AppRunnerError extends Error {
  AppRunnerError(this.message);

  final String message;

  @override
  String toString() {
    return "\nAppRunnerError: $message";
  }
}
