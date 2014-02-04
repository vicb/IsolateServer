part of CoreApi;

class Core {
  Dom             dom;
  Redirection     redir;
  Map             session;
  Map             request;
  Map             userInfo;

  Core(List<String> args) {
    dom = new Dom();
    redir = new Redirection();
    try {
      Map data = JSON.decode(args[1]);
      session = data["SESSION"];
      session["id"] = args[0];
      request = data["REQUEST"];
      userInfo = data["USER_INFO"];
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