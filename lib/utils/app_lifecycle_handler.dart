part of '../aio.dart';

/// A class to handle the app lifecycle.
///
/// Pass this class to [App.run] to handle the app lifecycle globally.
/// You can also use this class to handle the app lifecycle in a specific
/// widget by instantiating it and call [init] in the [initState] method
/// and disposing it in the [dispose] method.
class AppLifeCycleHandler extends WidgetsBindingObserver with Initializable {
  AppLifeCycleHandler({
    this.onDetached,
    this.onResumed,
    this.onInactive,
    this.onHidden,
    this.onPaused,
  });

  final void Function()? onDetached;
  final void Function()? onResumed;
  final void Function()? onInactive;
  final void Function()? onHidden;
  final void Function()? onPaused;

  @override
  void init(Object? options) {
    WidgetsBinding.instance.addObserver(this);

    super.init(options);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _requiresInitialization;
    switch (state) {
      case AppLifecycleState.detached:
        onDetached?.call();
        break;
      case AppLifecycleState.resumed:
        onResumed?.call();
        break;
      case AppLifecycleState.inactive:
        onInactive?.call();
        break;
      case AppLifecycleState.hidden:
        onHidden?.call();
        break;
      case AppLifecycleState.paused:
        onPaused?.call();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
