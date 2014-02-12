part of CoreApi;

class Core {
  Dom             dom;
  Redirection     redir;
  Map             session;
  Map             request;
  Map             userInfo;
  Map             serverInfo;
  String          contentType = "text/html; charset=UTF-8";

  Core(List<String> args) {
    dom = new Dom();
    redir = new Redirection();
    try {
      Map data = JSON.decode(args[0]);
      session = data["SESSION"];
      request = data["REQUEST"];
      userInfo = data["USER_INFO"];
      serverInfo = data["SERVER_INFO"];
    }
    catch (e) {
      print("Erreur: ${e}");
    }
  }
  
  void setContentType(String type) {
    contentType = type;
  }
  
  String toString() {
    Map rtc = new Map<String, dynamic>();
    rtc["DOM"] = dom.toString();
    rtc["REDIRECTION"] = redir.toString(); 
    rtc["SESSION"] = session;
    rtc["CONTENT_TYPE"] = contentType;
    return (JSON.encode(rtc));
  }
}