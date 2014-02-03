part of IsolateServer;

abstract class DataFile {
  void update(IO.HttpRequest req, IO.HttpServer hs, Request data);
}

class TempFile extends DataFile {
  String pathFile;
  
  TempFile(String dirPath) {
    pathFile = dirPath + "tmp";
  }
  
  void update(IO.HttpRequest req, IO.HttpServer hs, Request data) {
    IO.File tmpFile = new IO.File(pathFile);
    if (!tmpFile.existsSync())
      tmpFile.createSync();
    Map dataTmpFile = new Map<String, dynamic>();
    Map session = new Map<dynamic, dynamic>();
    req.session.forEach((dynamic key, dynamic value) {
      session[key] = value;
    });
    dataTmpFile["SESSION"] = session;
    
    Map userInfo = new Map<dynamic, dynamic>();
    userInfo["REMOTE_ADDRESS"] = req.connectionInfo.remoteAddress.address;
    userInfo["REMOTE_PORT"] = req.connectionInfo.remotePort;
    userInfo["LOCAL_PORT"] = req.connectionInfo.localPort;
    dataTmpFile["USER_INFO"] = userInfo;
    
    Map requestInfo = new Map<String, dynamic>();
    requestInfo["TYPE"] = data.type;
    Map queryParameter = new Map<String, String>();
    data.queryParam.forEach((key, value) {
      queryParameter[key] = value;
    });
    requestInfo["QUERYPARAM"] = queryParameter; 
    if (data.type == "POST") {
      Map postData = new Map<String, String>();
      String postSData = new String.fromCharCodes(data.data);
      List<String> listData = postSData.split("=");
      if (listData.length == 2) {
        for (int i = 0; i < listData.length; i += 2)
          postData[listData[i]] = Uri.decodeQueryComponent(listData[i + 1]);
      }
      else
        postData["DEFAULT"] = postSData;
      requestInfo["DATA"] = postData;
    }
    dataTmpFile["REQUEST"] = requestInfo;

    IO.IOSink ios = tmpFile.openWrite(mode: IO.WRITE);
    ios.write(JSON.encode(dataTmpFile));
    ios.close();
  }
}

class StaticFile extends DataFile {
  StaticFile(String dirPath) {
    
  }
  
  void update(IO.HttpRequest req, IO.HttpServer hs, Request data) {

  }
}

class DataManager {
  IO.Directory            sessDir;
  List<DataFile>          sessionFile;
  
  DataManager(IO.HttpRequest req, IO.HttpServer hs, Request data) {
    sessionFile = new List<DataFile>();
    sessDir = new IO.Directory("data/${req.session.id}/");
    req.session.onTimeout = _deleteDir;
    if (!sessDir.existsSync()) {
      sessDir.createSync();
    }
    if (sessionFile.length == 0) {
      sessionFile.add(new StaticFile(sessDir.path));
      sessionFile.add(new TempFile(sessDir.path));
    }
    update(req, hs, data);
  }
  
  void _deleteDir() {
    print("delete session ${sessDir.path}");
    sessDir.deleteSync(recursive: true);
  }
  
  void update(IO.HttpRequest req, IO.HttpServer hs, Request data) {
    sessionFile.forEach((DataFile sf) {
      sf.update(req, hs, data);
    });
  }
}