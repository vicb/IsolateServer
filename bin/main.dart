import 'dart:io' as IO;

import 'package:IsolateServer/IsolateServer/isolateserver.dart';

void main() {
  String address = "10.12.181.76";
  int port = 8888;
    
  IO.HttpServer.bind(address, port).then((IO.HttpServer hs) {
    IsolateServer isoServer = new IsolateServer(hs);
    isoServer.listen();
  });
}
