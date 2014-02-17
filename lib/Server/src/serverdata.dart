part of IsolateServer;

class ServerData {
  Map dataTmpFile;
  
  static final Map<String, ServerData> cache = new Map<String, ServerData>();
  
  factory ServerData(String id, IO.HttpRequest req, IO.HttpServer hs) {
    if (cache.containsKey(id))
      return (cache[id]);
    else {
      final ServerData serverData = new ServerData.internal(req, hs);    
      cache[id] = serverData;
      return (serverData);
    }
  }
  
  ServerData.internal(IO.HttpRequest req, IO.HttpServer hs) {
    dataTmpFile = new Map<String, dynamic>();
    Map userInfo = new Map<dynamic, dynamic>();
    userInfo["REMOTE_ADDRESS"] = req.connectionInfo.remoteAddress.address;
    userInfo["REMOTE_PORT"] = req.connectionInfo.remotePort;
    userInfo["LOCAL_PORT"] = req.connectionInfo.localPort;
    dataTmpFile["USER_INFO"] = userInfo;
    
    Map serverInfo = new Map<String, dynamic>();
    serverInfo["ADDRESS"] = hs.address.address;
    serverInfo["PORT"] = hs.port;
    dataTmpFile["SERVER_INFO"] = serverInfo;
    
    Map session = new Map<dynamic, dynamic>();
    session["id"] = req.session.id;
    dataTmpFile["SESSION"] = session;
    
    Map requestInfo = new Map<String, dynamic>();
    dataTmpFile["REQUEST"] = requestInfo;
  }
    
  String getServerData(IO.HttpRequest req, IO.HttpServer hs, String data) {
    Map session = dataTmpFile["SESSION"];
    req.session.forEach((dynamic key, dynamic value) {
      session[key] = value;
    });
    
    Map userInfo = dataTmpFile["USER_INFO"];
    userInfo[IO.HttpHeaders.REFERER] = req.headers[IO.HttpHeaders.REFERER];

    Map requestInfo = dataTmpFile["REQUEST"];
    requestInfo["TYPE"] = req.method;
    Map queryParameter = new Map<String, String>();
    req.uri.queryParameters.forEach((key, value) {
      queryParameter[key] = value;
    });
    requestInfo["QUERYPARAM"] = queryParameter; 
    if (req.method == "POST") {
      Map postData = new Map<String, String>();
      List<String> listData = data.split("=");
      if (listData.length == 2) {
        for (int i = 0; i < listData.length; i += 2)
          postData[listData[i]] = Uri.decodeQueryComponent(listData[i + 1]);
      }
      else
        postData["DEFAULT"] = data;
      requestInfo["DATA"] = postData;
    }
    return (JSON.encode(dataTmpFile));
  }
}
