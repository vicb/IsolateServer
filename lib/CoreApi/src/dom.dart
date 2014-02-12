part of CoreApi;

class Dom {
  Element dom;
  Element head;
  Element body;
  
  Dom() {
    dom = new Element.tag('html');
    head = new Element.tag('head');
    body = new Element.tag('body');
    dom.appendChild(head);
    dom.appendChild(body);
  }
  
  void setTitle(String title) {
    Element eTitle = new Element.tag('title');
    eTitle.innerText = title;
    head.appendChild(eTitle);
  }
  
  void addScriptToHead(String src, String type) {
    Element script = new Element.tag('script');
    if (src.endsWith(".dart"))
      script["src"] = "/client" + src;
    else
      script["src"] = src;
    script["type"] = type;
    head.appendChild(script);
  }
  
  void addStyleSheetToHead(String href) {
    Element ss = new Element.tag('link');
    ss["rel"] = "stylesheet";
    ss["type"] = "text/css";
    ss["href"] = href;
    head.appendChild(ss);
  }
  
  void appendToBody(Element child) {
    body.appendChild(child); 
  }
  
  String toString() => "<!DOCTYPE html>${dom.toString()}";
}