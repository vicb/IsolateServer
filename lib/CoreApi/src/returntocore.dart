part of CoreApi;

class ReturnToCore {
  Dom             dom;
  Redirection     redir;
  
  ReturnToCore() {
    dom = new Dom();
    redir = new Redirection();
  }
  
  String toString() {
    Map rtc = new Map<String, dynamic>();
    rtc["DOM"] = dom.toString();
    rtc["REDIRECTION"] = redir.toString(); 
    return (JSON.encode(rtc));
  }
}