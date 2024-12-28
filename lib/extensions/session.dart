part of '../aio.dart';

/// This extension is used to manage the session of the app.
/// It uses the [FlutterSecureStorage] package to store critical data.
///
/// To use this extension, you must call `App().session` to get the session object.
extension AppSession on App {
  static final _session = Expando<Session>();

  /// Initializes the session of the app.
  Future<void> _initSession() async {
    _session[this] = Session();
    await _session[this]!._init();
  }

  /// Gets the session of the app.
  /// If the session is not initialized, it will throw an error.
  /// To initialize the session, set [useAppSession] to true in [App().run()].
  Session get session {
    if (_session[this] == null) {
      throw "AppSession not initialized. Set [useAppSession] to true in App().run()";
    }

    return _session[this]!;
  }
}

/// A class to manage the session of the app.
/// You must call [_init] to retrieve the session data from the secure storage.
///
/// Use [save] to save the token and [clear] to clear the token.
/// Use [isLogged] to check if the user is logged in.
class Session {
  Session();

  String? _token;

  bool get isLogged => _token != null;

  /// Saves the token and calls the [onSave] callback.
  Future<void> save(String token, {void Function()? onSave}) async {
    _token = token;

    await _saveSession();
    onSave?.call();
  }

  /// Clears the token and calls the [onClear] callback.
  Future<void> clear([void Function()? onClear]) async {
    _token = null;
    await _clearSession();
  }

  static const String _keyToken = "_token";

  Future<void> _init() async {
    const storage = FlutterSecureStorage();
    _token = await storage.read(key: _keyToken);
  }

  /// Saves the session token in the secure storage.
  Future<void> _saveSession() async {
    const storage = FlutterSecureStorage();
    await storage.write(key: _keyToken, value: _token);
  }

  /// Clears the session token from the secure storage.
  Future<void> _clearSession() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: _keyToken);
  }
}
