part of '../aio.dart';

/// Provides a way to check if an object has been initialized.
///
/// This mixin should be used by classes that require initialization before
/// they can be used. The [init] method should be called before any other methods.
///
/// If a method requires initialization, it should call [_requiresInitialization]
/// at the beginning of the method to ensure that the object has been initialized.
///
/// If the object has not been initialized, a [StateError] will be thrown.
mixin Initializable {
  bool _initialized = false;

  /// Initializes the object with the given options.
  ///
  /// You must call `super.init()` in the overridden method.
  /// This call must occur when any required initialization is complete.
  /// For example, if the object requires a async operation to complete
  /// before it can be used, the `super.init()` call should be made after
  /// the async operation is complete.
  @mustCallSuper
  void init(Object? options) {
    _initialized = true;
  }

  /// Throws an error if the object has not been initialized.
  /// This method should be called at the beginning of any method that
  /// requires initialization.
  void get _requiresInitialization {
    if (_initialized) return;
    throw _InitializationError();
  }
}

/// Error thrown when an object has not been initialized.
///
/// This error is thrown when a method is called on an object that requires
/// initialization, but the object has not been initialized.
///
/// To fix this error, call the [init] method before using any other methods.
class _InitializationError extends Error {
  _InitializationError();

  @override
  String toString() {
    return """InitializationError: The object has not been initialized. """
        """Call the init method before using any other methods.""";
  }
}
