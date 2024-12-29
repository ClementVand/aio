part of '../../aio.dart';

// TODO: Keep logs between session ?
// - If true, written to file and concatenated to new logs
// - If false, written to file and overwritten by new logs

/// A mixin to add logging functionality to a class.
///
/// [Logger] is enabled by [App.run] when the `debug` parameter is set to `true`.
/// To manually enable logging, set [Logger.enabled] to `true`.
///
/// Logs are written to a file in the app's cache directory.
/// Logs can be retrieved using [Logger.getLogs] or [Logger.getRawLogs].
/// Or they can be displayed using the [LoggerView] widget.
mixin Logger<T> {
  static bool enabled = false;
  static File? _logFile;

  /// Logs a message with the given [level] and [tag].
  /// Only logs if [Logger.enabled] is `true`.
  static void log(
    String message, {
    LoggerLevel level = LoggerLevel.info,
    LoggerTag tag = LoggerTag.global,
  }) {
    if (!enabled) return;

    final String log = _serialize(message, level, tag);
    _writeToFile(log);
  }

  /// Get logs as a list of strings.
  static Future<List<String>> getRawLogs() async {
    final List<String> logs = await _getLogFile().then(
      (file) => file
          .readAsStringSync()
          .split("</>")
          .map(
            (log) {
              if (log.isEmpty || log.length < 28) return null;
              // Remove the level and tag from the serialized log
              log.replaceRange(26, 27, " - ");
              return log;
            },
          )
          .nonNulls
          .toList(),
    );
    return logs;
  }

  /// Get logs as a list of [Log] objects.
  static Future<List<Log>> getLogs() async {
    final List<String> logs = await _getLogFile().then((file) => file.readAsStringSync().split("</>"));
    return logs.map((log) => _deserialize(log)).nonNulls.toList();
  }

  static Future<void> clearLogs() async {
    final File logFile = await _getLogFile();
    logFile.writeAsStringSync("");
  }

  static String _serialize(String message, LoggerLevel level, LoggerTag tag) {
    // Date                Level-||-Tag         Message|
    // |                         ||                    |
    // |-------------------------||--------------------|
    // 2024-09-05T18:47:57.59078421This is a log message
    return "${DateTime.now().toIso8601String()}${level.index.toString()}${tag.index.toString()}$message";
  }

  static Log? _deserialize(String log) {
    if (log.isEmpty || log.length < 28) return null;

    final DateTime time = DateTime.parse(log.substring(0, 25));
    final LoggerLevel level = LoggerLevel.values[int.parse(log[26])];
    final LoggerTag tag = LoggerTag.values[int.parse(log[27])];
    final String message = log.substring(28);

    return Log(message: message, date: time.toIso8601String(), level: level, tag: tag);
  }

  static void _writeToFile(String message) async {
    final File logFile = await _getLogFile();
    final String log = "$message</>";

    logFile.writeAsStringSync(log, mode: FileMode.append);
    // logFile.writeAsStringSync(log);
  }

  static Future<File> _getLogFile() async {
    if (_logFile != null) return _logFile!;

    final Directory appDirectory = await getApplicationCacheDirectory();
    final Directory logsDirectory = Directory('${appDirectory.path}/logs');

    // Create the directory if it doesn't exist
    if (!logsDirectory.existsSync()) {
      logsDirectory.createSync();
    }

    final File file = File("${logsDirectory.path}/logs.txt");
    if (!file.existsSync()) {
      file.createSync();
    }

    _logFile = file;
    return file;
  }
}

/// Object representing a log entry.
class Log {
  Log({
    required this.message,
    required this.date,
    required this.level,
    required this.tag,
  });

  final String message;
  final String date;
  final LoggerLevel level;
  final LoggerTag tag;

  Color get color {
    switch (level) {
      case LoggerLevel.warning:
        return const Color(0xFFFFBB00);
      case LoggerLevel.error:
        return const Color(0xFFCC3000);
      default:
        return const Color(0xFFBBBBBB);
    }
  }

  @override
  String toString() {
    return "[${level.name}: ${tag.name}] $date: $message";
  }
}

typedef Logs = List<Log>;

/// Up to 10 levels of logging (0-9) are supported.
enum LoggerLevel {
  info,
  warning,
  error,
}

/// Up to 10 tags (0-9) are supported.
/// Tags are used to categorize logs.
enum LoggerTag {
  global,
  network,
}
