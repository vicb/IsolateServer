part of IsolateServer;

class Request {
  String        type;
  String        data;
  Map           queryParam;
  
  Request(String this.type, String this.data, Map this.queryParam);
}