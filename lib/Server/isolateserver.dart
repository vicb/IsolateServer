library IsolateServer;

import 'dart:io' as IO;
import 'dart:isolate';
import 'dart:convert';

part 'src/serverdata.dart';

class IsolateServer {
  IO.HttpServer           _hs;
  Map                     wsRoad;
  Map                     _contentType;
  
  IsolateServer(IO.HttpServer this._hs) {
    wsRoad = new Map<String, Function>();
    _contentType = new Map<String, String>();
    IO.File cT = new IO.File("packages/isolateserver/Server/configuration/ContentType");
    cT.readAsLinesSync().forEach((String line) {
      var tabData = line.split(" ");
      if (tabData.length == 2)
        _contentType[tabData[0]] = tabData[1];
    });
  }
  
  void _stopAndPrintStopwatch(Stopwatch sw, IO.HttpRequest req) {
    sw.stop();
    print("Response time for ${req.uri.path}: ${sw.elapsed}");
  }
  
  void _spawnDart(IO.HttpRequest req, String path, Stopwatch sw, String data) {
    try {
      ServerData serverData = new ServerData(req.session.id, req, this._hs);
      ReceivePort response = new ReceivePort();
      Isolate.spawnUri(Uri.parse("../" + path), [serverData.getServerData(req, _hs, data)], response.sendPort);      
      response.listen((data) {
        Map mapData = JSON.decode(data);
        String contentType = mapData["CONTENT_TYPE"];
        req.response.headers.set(IO.HttpHeaders.CONTENT_TYPE, contentType);
        if (mapData["REDIRECTION"] == "")
          req.response.write(mapData["DOM"]);
        else
          req.response.headers.set("Refresh", "0; url=${mapData["REDIRECTION"]}");
        Map session = mapData["SESSION"];
        if (session != null) {
          session.forEach((dynamic key, dynamic value) {
            req.session[key] = value;
          });
        }
        req.response.close();
        this._stopAndPrintStopwatch(sw, req);
      });
    }
    catch (e) {
      this._fileNotExist(req, sw, data);
    }
  }
  
  String _getContentType(String path) {
    String content = "text/plain";
    _contentType.forEach((String key, String value) {
      if (path.endsWith(key))
        content = value;
    });
    return (content);
  }
  
  void _fileExist(IO.HttpRequest req, IO.File file, Stopwatch sw, String data) {
    String pathFile = file.path;
    if (pathFile.endsWith(".dart"))
      this._spawnDart(req, pathFile, sw, data);
    else {
      String contentType = _getContentType(pathFile);
      req.response.headers.set(IO.HttpHeaders.CONTENT_TYPE, contentType);
      file.openRead().pipe(req.response).catchError((e) { print('error pipe!'); });
      this._stopAndPrintStopwatch(sw, req);
    }
  }
  
  void _fileNotExist(IO.HttpRequest req, Stopwatch sw, String data) {
    IO.File error = new IO.File("web/error/404.dart");
    if (error.existsSync()) 
      this._spawnDart(req, "../web/error/404.dart", sw, data);
    else {
      req.response.statusCode = IO.HttpStatus.NOT_FOUND;
      req.response.write("NOT FOUND !");
      req.response.close();
      this._stopAndPrintStopwatch(sw, req);
    }
  }
  
  void _getData(IO.HttpRequest req, String data, Stopwatch sw) {
    String pathFile = this._getPathFile(req);
    IO.File file = new IO.File(pathFile);
    if (wsRoad.containsKey(req.uri.path)) { 
      IO.WebSocketTransformer.upgrade(req).then((IO.WebSocket ws) {
        wsRoad[req.uri.path](ws, req);
      });
    }
    else if (file.existsSync())
      this._fileExist(req, file, sw, data);
    else
      this._fileNotExist(req, sw, data);
  }
  
  String _getPathFile(IO.HttpRequest req) {
    String pathFile = "web";
    bool isClient = req.uri.path.contains("/client");
    if (req.uri.path.endsWith("/") && !isClient)
      pathFile += req.uri.path + "index.dart";
    else {
      if (isClient)
        pathFile += req.uri.path.substring(7, req.uri.path.length);
      else
        pathFile += req.uri.path;
    }
    return (pathFile);
  }
  
  void listen() {
    this._hs.listen((IO.HttpRequest req) {
      Stopwatch sw = new Stopwatch();
      sw.start();
      UTF8.decodeStream(req).then((String data) {
        _getData(req, data, sw);
      }, onError: (e) {
        print(e);
      });      
    });
  }
}