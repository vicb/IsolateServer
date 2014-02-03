library IsolateServer;

import 'dart:io' as IO;
import 'dart:isolate';
import 'dart:async';
import 'dart:convert';

part 'src/request.dart';
part 'src/datamanager.dart';

class IsolateServer {
  IO.HttpServer           hs;
  
  IsolateServer(IO.HttpServer this.hs) {
    IO.Directory dataDir = new IO.Directory("data/");
    dataDir.list().listen((IO.FileSystemEntity fse) {
      fse.deleteSync(recursive: true);
    });
  }
  
  void _stopAndPrintStopwatch(Stopwatch sw, IO.HttpRequest req) {
    sw.stop();
    print("Response time for ${req.uri.path}: ${sw.elapsed}");
  }
  
  void _spawnDart(IO.HttpRequest req, String path, Stopwatch sw, Request request) {
    try {
      DataManager dataManager = new DataManager(req, hs, request);
      var response = new ReceivePort();
      Isolate.spawnUri(Uri.parse("../" + path), [req.session.id], response.sendPort);
      response.listen((data) {
        Map mapData = JSON.decode(data);
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
      this._fileNotExist(req, sw, request);
    }
  }
  
  void _fileExist(IO.HttpRequest req, IO.File file, Stopwatch sw, Request request) {
    String pathFile = file.path;
    if (pathFile.endsWith(".dart"))
      this._spawnDart(req, pathFile, sw, request);
    else {
      file.openRead().pipe(req.response).catchError((e) { print('error pipe!'); });
      this._stopAndPrintStopwatch(sw, req);
    }
  }
  
  void _fileNotExist(IO.HttpRequest req, Stopwatch sw, Request request) {
    IO.File error = new IO.File("web/error/404.dart");
    if (error.existsSync())
      this._spawnDart(req, "../web/error/404.dart", sw, request);
    else {
      req.response.write("NOT FOUND !");
      req.response.close();
      this._stopAndPrintStopwatch(sw, req);
    }
  }
  
  void _getData(IO.HttpRequest req, List<int> data, Stopwatch sw) {
    Request request = new Request(req.method, data, req.requestedUri.queryParameters);
    String pathFile = this._getPathFile(req);
    IO.File file = new IO.File(pathFile);
    if (file.existsSync())
      this._fileExist(req, file, sw, request);
    else
      this._fileNotExist(req, sw, request);
  }
  
  String _getPathFile(IO.HttpRequest req) {
    String pathFile = "web";
    if (req.uri.path.endsWith("/"))
      pathFile += req.uri.path + "index.dart";
    else
      pathFile = req.uri.path;
    return (pathFile);
  }
  
  void listen() {
    this.hs.listen((IO.HttpRequest req) {
      Stopwatch sw = new Stopwatch();
      sw.start();
      List<int> allData = new List<int>();
      req.listen((List<int> data) => allData.addAll(data), onDone: () {
        _getData(req, allData, sw);
      }, onError: (e) {
        print(e);
      }, cancelOnError: true);
    });
  }
}