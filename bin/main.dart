import 'dart:io' as IO;
import 'dart:async';

import 'package:IsolateServer/IsolateServer/isolateserver.dart';

void main() {
  String address = "10.12.180.159";
  int port = 8888;
  
  IO.HttpServer.bind(address, port).then((IO.HttpServer hs) {
    IsolateServer isoServer = new IsolateServer(hs);
    isoServer.listen();
  });
}
