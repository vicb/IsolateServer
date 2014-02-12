part of CoreApi;

class Core {
  Dom             dom;
  Redirection     redir;
  Map             session;
  Map             request;
  Map             userInfo;
  Map             serverInfo;

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
  
  String toString() {
    Map rtc = new Map<String, dynamic>();
    rtc["DOM"] = dom.toString();
    rtc["REDIRECTION"] = redir.toString(); 
    rtc["SESSION"] = session;
    return (JSON.encode(rtc));
  }
}