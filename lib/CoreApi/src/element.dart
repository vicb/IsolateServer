part of CoreApi;

class Element {
  String                tagName;
  List<Element>         children;
  Element               parent;
  Map<String, String>   attributes;
  String                text = "";
  
  Element.tag(String tag) {
    tagName = tag;
    children = new List<Element>();
    attributes = new Map<String, String>();
  }
  
  void appendChild(Element elem) {
    children.add(elem);
    elem.parent = this;
  }
  
  void innerText(String txt) {
    text = txt;
  }
  
  String operator [](String key) {
    return (attributes[key]);
  }

  void operator []=(String key, String value) {
    attributes[key] = value;
  }
  
  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("<");
    sb.write(tagName);
    if (attributes.length > 0)
      sb.write(" ");
    attributes.forEach((String key, String value) {
      sb.write("${key}='${value}'");
      sb.write(" ");
    });
    sb.write(">");
    sb.write(text);
    children.forEach((Element elem) {
      sb.write(elem.toString());
    });
    sb.write("</${tagName}>");
    return (sb.toString());
  }
}