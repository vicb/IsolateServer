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
    
  }
  
  void addToBody(Element child) {
    body.appendChild(child); 
  }
  
  String toString() => "<!DOCTYPE html>${dom.toString()}";
}