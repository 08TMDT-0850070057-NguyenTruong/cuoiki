import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? _socket;
  String? authorizationToken;

  //init
  SocketService({required this.authorizationToken}) {
    // ignore: avoid_print
    print('Connecting to socket');
    // ignore: unused_local_variable
    Map<String, dynamic> query = {
      'authorization': authorizationToken,
    };
    _socket = io.io(
      'http://192.168.1.8:3000',
      io.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .disableAutoConnect()
          .setAuth({'authorization': authorizationToken})
          .setExtraHeaders({'authorization': authorizationToken})
          .build(),
    );
    _socket?.connect();
  }

  void onEvent(String eventName, Function(dynamic data) callback) {
    _socket?.on(eventName, (data) {
      callback(data);
    });
  }

  void emitEvent(String eventName, dynamic data) {
    _socket?.emit(eventName, data);
  }

  void closeConnection() {
    _socket?.disconnect();
  }
}
