import 'dart:html';
import 'dart:async';

WebSocket ws;

outputMsg(String msg) {
  print("Message: " + msg);
}

void initWebSocket([int retrySeconds = 2]) {
  var reconnectScheduled = false;

  outputMsg("Connecting to websocket");
  ws = new WebSocket('ws://10.12.181.76:8888/ws/');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    outputMsg('Connected');
    ws.send('Hello from Dart!');
  });

  ws.onClose.listen((e) {
    outputMsg('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    outputMsg("Error connecting to ws");
    scheduleReconnect();
  });

  ws.onMessage.listen((MessageEvent e) {
    outputMsg('Received message: ${e.data}');
  });
}

void main() {
  initWebSocket();
  print("Hello World !");
}