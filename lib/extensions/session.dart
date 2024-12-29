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

  User? _user;

  bool get isLogged => _user != null;

  /// Saves the token and calls the [onSave] callback.
  Future<void> save(User user, {void Function()? onSave}) async {
    _user = user;

    await _saveSession();
    onSave?.call();
  }

  /// Clears the token and calls the [onClear] callback.
  Future<void> clear([void Function()? onClear]) async {
    _user = null;
    await _clearSession();
  }

  static const String _keyUser = "_user";

  Future<void> _init() async {
    const storage = FlutterSecureStorage();
    String? data = await storage.read(key: _keyUser);
    _user = User.parse(data);
  }

  /// Saves the session token in the secure storage.
  Future<void> _saveSession() async {
    const storage = FlutterSecureStorage();
    await storage.write(key: _keyUser, value: _user?.serialize());
  }

  /// Clears the session token from the secure storage.
  Future<void> _clearSession() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: _keyUser);
  }
}

/// A model to store the user data.
class User {
  User({
    required this.email,
    required this.token,
  });

  User.parse(String? data) {
    if (data == null) return;

    final parts = data.split("<|>");

    email = parts[0];
    token = parts[1];
  }

  late final String? email;
  late final String? token;

  String serialize() {
    return "${email ?? ""}<|>${token ?? ""}";
  }
}
