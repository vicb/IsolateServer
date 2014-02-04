part of IsolateServer;

class ManageServerData {
  Map     ServerDatas;
  
  ManageServerData() {
    
  }
}

class ServerData {
  final String  id;
  
  Map dataTmpFile;
  
  static final Map<String, ServerData> cache = new Map<String, ServerData>();
  
  factory ServerData(String id, IO.HttpRequest req) {
    if (cache.containsKey(id))
      return (cache[id]);
    else {
      final ServerData serverData = new ServerData.internal(id, req);    
      cache[id] = serverData;
      return (serverData);
    }
  }
  
  ServerData.internal(String this.id, IO.HttpRequest req) {
    dataTmpFile = new Map<String, dynamic>();
    Map userInfo = new Map<dynamic, dynamic>();
    userInfo["REMOTE_ADDRESS"] = req.connectionInfo.remoteAddress.address;
    userInfo["REMOTE_PORT"] = req.connectionInfo.remotePort;
    userInfo["LOCAL_PORT"] = req.connectionInfo.localPort;
    dataTmpFile["USER_INFO"] = userInfo;
    
    Map session = new Map<dynamic, dynamic>();
    session["id"] = req.session.id;
    dataTmpFile["SESSION"] = session;
    
    Map requestInfo = new Map<String, dynamic>();
    dataTmpFile["REQUEST"] = requestInfo;
  }
    
  String getServerData(IO.HttpRequest req, IO.HttpServer hs, Request request) {
    Map session = dataTmpFile["SESSION"];
    req.session.forEach((dynamic key, dynamic value) {
      session[key] = value;
    });
    
    Map requestInfo = dataTmpFile["REQUEST"];
    requestInfo["TYPE"] = request.type;
    Map queryParameter = new Map<String, String>();
    request.queryParam.forEach((key, value) {
      queryParameter[key] = value;
    });
    requestInfo["QUERYPARAM"] = queryParameter; 
    if (request.type == "POST") {
      Map postData = new Map<String, String>();
      List<String> listData = request.data.split("=");
      if (listData.length == 2) {
        for (int i = 0; i < listData.length; i += 2)
          postData[listData[i]] = Uri.decodeQueryComponent(listData[i + 1]);
      }
      else
        postData["DEFAULT"] = request.data;
      requestInfo["DATA"] = postData;
    }

    return (JSON.encode(dataTmpFile));
  }
}
