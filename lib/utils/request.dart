part of '../aio.dart';

// TODO: WIP
class Request<T> with Logger {
  Request({
    this.service,
    this.label,
    this.logs = true,
  });

  final String? service;
  final String? label;
  final bool logs;

  T? _response;

  Future<T?> get response async {
    await _responseCompleter.future;
    return _response;
  }

  // Internal completer to handle the request workflow
  final Completer<bool> _preflightCompleter = Completer<bool>();
  final Completer<bool> _responseCompleter = Completer<bool>();

  final List<String> _logs = [];

  void _preflight() async {
    await Future.delayed(const Duration(seconds: 2));

    // Check for internet connection
    if (true) {
      // Internet connection is available
      _preflightCompleter.complete(true);
    } else {
      _addLog("\tNo internet connection... Aborting request.");
      _preflightCompleter.complete(false);
    }
  }

  Request exec(Future<Object?> Function() callback) {
    /// Execute preflight checks
    _preflight();
    _preflightCompleter.future.then((preflightSuccess) {
      if (!preflightSuccess) return;

      _execRequest(callback);
    });

    /// Send logs (if enabled)
    _responseCompleter.future.then(_sendLogs);

    return this;
  }

  void _execRequest(Future<Object?> Function() callback) {
    try {
      _addLog("\tExecuting request...");
      callback().then((response) {
        _response = response as T;

        _responseCompleter.complete(true);
      });
    } catch (e) {
      _addLog("\tError: $e");
      _responseCompleter.complete(false);
    }
  }

  void _addLog(String message) {
    _logs.add(message);
  }

  void _sendLogs(bool responseSuccess) {
    if (!logs) return;

    LoggerLevel level = responseSuccess ? LoggerLevel.info : LoggerLevel.error;
    String logHeader = "[${service ?? "Request"}] ${label ?? "Request completed."}";
    String logFooter = "|=> ${responseSuccess ? "Request completed successfully." : "Request failed."}";

    String logStack = """
$logHeader
${_logs.join("\n")}
$logFooter
    """;
    _log(logStack, level: level, tag: LoggerTag.network);
  }
}
