import 'dart:io' as IO;

import 'package:IsolateServer/Server/isolateserver.dart';

void main() {
  String address = IO.InternetAddress.LOOPBACK_IP_V4.address;
  int port = 8888;
  
  IO.HttpServer.bind(address, port).then((IO.HttpServer hs) {
    IsolateServer isoServer = new IsolateServer(hs);
    
    isoServer.wsRoad["/ws/"] = (IO.WebSocket ws, IO.HttpRequest req) {
      print("new WebSocket !");
      ws.listen((data) {
        ws.add("Hello from Server !");
      });
    };
    
    isoServer.listen();
  });
}
