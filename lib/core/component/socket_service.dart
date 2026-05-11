import '../exporters/app_export.dart';

enum SocketStatus { connecting, connected, disconnected }

SocketStatus socketStatus = SocketStatus.connecting;

Function(SocketStatus status)? onStatusChange;
Function(String event, Map<String, dynamic> data)? onEvent;

WebSocketChannel? _channel;
String? _currentConvId;

void connect(String convId, {bool isGlobal = false}) {
  if (_currentConvId == convId && _channel != null) return;

  disconnect();
  _currentConvId = convId;

  final wsUrl =
      "ws://beta.madhyasthi.com/app/${AppConstants.chatApiKey}?protocol=7&client=flutter&version=1.0";
  _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

  _channel!.stream.listen(
    (event) {
      final decoded = jsonDecode(event);
      print('event=========>${decoded['event']}');

      /// ✅ HANDLE PING → SEND PONG
      if (decoded['event'] == 'pusher:ping') {
        _channel?.sink.add(jsonEncode({"event": "pusher:pong"}));

        return;
      }

      /// ✅ CONNECTED
      if (decoded['event'] == 'pusher:connection_established') {
        onStatusChange?.call(SocketStatus.connected);
        if (isGlobal) {
          _subscribeGlobal(convId);
        } else {
          _subscribe(_currentConvId!);
        }

        return;
      }

      /// IGNORE INTERNAL EVENTS
      if (decoded['event'] == null ||
          decoded['event'].toString().startsWith("pusher")) {
        return;
      }

      final eventName = decoded['event'];
      final raw = decoded['data'];
      final data = raw is String ? jsonDecode(raw) : raw;

      onEvent?.call(eventName, data);
    },
    onDone: () {
      onStatusChange?.call(SocketStatus.disconnected);
    },
    onError: (e) {
      onStatusChange?.call(SocketStatus.disconnected);
    },
  );
}

void _subscribe(String convId) {
  _channel?.sink.add(
    jsonEncode({
      "event": "pusher:subscribe",
      "data": {"channel": "chat.$convId"},
    }),
  );
}

void _subscribeGlobal(String userId) {
  _channel?.sink.add(
    jsonEncode({
      "event": "pusher:subscribe",
      "data": {"channel": "user.$userId.global"},
    }),
  );
}

void disconnect() {
  _channel?.sink.close();
  _channel = null;
  _currentConvId = null;

  socketStatus = SocketStatus.disconnected;
  onStatusChange?.call(socketStatus);
}
