part of '../../aio.dart';

class LoggerView extends StatefulWidget {
  const LoggerView({super.key});

  @override
  State<LoggerView> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<LoggerView> {
  Logs _logs = [];
  bool _viewRawLogs = false;

  @override
  void initState() {
    super.initState();

    _refreshLogs();
  }

  void _refreshLogs() async {
    Logs logs = await Logger.getLogs();
    setState(() {
      _logs = logs;
    });
  }

  void _clearLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear logs"),
        content: const Text("Are you sure you want to clear all logs?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Logger.clearLogs();
              setState(() {
                _logs = [];
              });
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  void _toggleViewRawLogs() {
    setState(() {
      _viewRawLogs = !_viewRawLogs;
    });
  }

  void _saveToClipboard() async {
    await Clipboard.setData(
      ClipboardData(
        text: _logs.map((log) => log.toString()).join("\n"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logs"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshLogs,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _toggleViewRawLogs,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearLogs,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _saveToClipboard,
          ),
        ],
      ),
      body: _viewRawLogs ? _buildRawLogs() : _buildLogs(),
    );
  }

  Widget _buildLogs() {
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final Log log = _logs[index];
        final int length = log.message.length;

        return ListTile(
          title: Text(
            length > 64 ? "${log.message.substring(0, 64)}...." : log.message,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            log.date.toString(),
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: log.color,
            radius: 15,
            child: Text(log.level.name[0]),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${log.level.name} - ${log.tag.name}"),
                    Text(log.date, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                content: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(log.message),
                  ),
                ),
                insetPadding: const EdgeInsets.all(16),
                actions: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRawLogs() {
    return ListView.builder(
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final Log log = _logs[index];

        return ListTile(
          title: Text(
            log.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
