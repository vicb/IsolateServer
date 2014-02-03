part of IsolateServer;

class TempFile {
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

    tmpFile.writeAsStringSync(JSON.encode(dataTmpFile), mode: IO.WRITE);
  }
}
