part of CoreApi;

class Core {
  Dom             dom;
  Redirection     redir;
  Map             session;
  Map             request;
  Map             userInfo;

  Core(String arg) {
    dom = new Dom();
    redir = new Redirection();
    IO.File sessDir = new IO.File("data/${arg}/tmp");
    if (sessDir.existsSync()) {
      List<String> lData = sessDir.readAsLinesSync();
      try {
        Map data = JSON.decode(lData[0]);
        session = data["SESSION"];
        request = data["REQUEST"];
        userInfo = data["USER_INFO"];
      }
      catch (e) {
        print("Erreur: ${e}");
      }
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