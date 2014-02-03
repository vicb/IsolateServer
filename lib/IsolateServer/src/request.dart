part of IsolateServer;

class Request {
  String        type;
  List<int>     data;
  Map           queryParam;
  
  Request(String this.type, List<int> this.data, Map this.queryParam);
}