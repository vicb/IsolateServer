part of CoreApi;

class Redirection {
  String redirection = "";
  
  Redirection();
  
  void add(String redir) {
    redirection = redir;
  }
  
  String toString() => redirection;
}