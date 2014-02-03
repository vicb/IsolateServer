part of IsolateServer;

class StaticFile {
  StaticFile(String dirPath) {
    
  }
  
  void update(IO.HttpRequest req, IO.HttpServer hs, Request data) {

  }
}

class DataManager {
  IO.Directory            sessDir;
  TempFile                tmpFile;
  
  DataManager(IO.HttpRequest req, IO.HttpServer hs, Request data) {
    sessDir = new IO.Directory("data/${req.session.id}/");
    req.session.onTimeout = _deleteDir;
    if (!sessDir.existsSync()) {
      sessDir.createSync();
    }
    if (tmpFile == null)
      tmpFile = new TempFile(sessDir.path);
    update(req, hs, data);
  }
  
  void _deleteDir() {
    print("delete session ${sessDir.path}");
    sessDir.deleteSync(recursive: true);
  }
  
  void update(IO.HttpRequest req, IO.HttpServer hs, Request data) {
    tmpFile.update(req, hs, data);
  }
}