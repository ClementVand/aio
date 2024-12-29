part of '../aio.dart';

/// An abstract class that represents an application dependency.
///
/// This class should be extended by any class that the app depends on.
///
/// It provides:
///   - a method to initialize the dependency with options. (using the [Initializable] mixin)
///   - a method to log messages. (using the [Logger] mixin)
///
/// To use this class, extend it and implement the [init] method.
///
/// Example:
/// ```dart
/// // Don't forget to pass the class type to the generic type parameter
/// class AppDependency extends Dependency<AppDependency> {
///   @override
///   void init(Object? options) { // Can be async
///     // Initialization code here (e.g. connecting to a database)
///
///     // Call the super init method to mark the dependency as initialized
///     super.init(options);
///   }
/// }
/// ```
abstract class Dependency<T extends Dependency<T>> with Initializable, Logger<T> {
  /// Initializes the dependency with the given options.
  /// This method should be overridden by the subclass.
  /// It is overridden as `async` to allow for asynchronous initialization.
  @override
  Future<void> init(Object? options) async {
    _log("Initialized [$T] with options: $options");
    super.init(options);
  }
}

/// An object that represents an initializable class with options.
class InitializableDependency {
  /// Creates a new initializable object with the given class.
  /// If the class requires options, use the [InitializableDependency.withOptions] constructor.
  InitializableDependency(
    this.initializableDependency, {
    this.mandatory = false,
  }) : options = null;

  /// Creates a new initializable object with the given class and options.
  InitializableDependency.withOptions(
    this.initializableDependency,
    this.options, {
    this.mandatory = false,
  });

  final Dependency initializableDependency;
  final Object? options;

  /// If `true`, the dependency is mandatory and must be initialized before
  /// running the app. In case of an error, the app will not run and will run
  /// a fallback widget instead. (see [App.run] method, `errorWidget` parameter)
  final bool mandatory;
}

class DependencyError extends Error {
  DependencyError(this.type);

  final DependencyErrorType type;

  @override
  String toString() {
    switch (type) {
      case DependencyErrorType.needsOptions:
        return "Dependency needs options to initialize. Use the `InitializableDependency.withOptions` constructor.";
      case DependencyErrorType.wrongArguments:
        return "Wrong arguments provided to the dependency.";
    }
  }
}

enum DependencyErrorType {
  needsOptions,
  wrongArguments,
}
