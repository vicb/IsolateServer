import 'dart:isolate';

import 'package:IsolateServer/CoreApi/all.dart';

void main(List<String> args, SendPort replyTo) {
  print(args);
  ReturnToCore rtc = new ReturnToCore();

  Element container = new Element.tag('div');
  Element form = new Element.tag('form');
  form["action"] = "/";
  form["method"] = "POST";
  Element inputText = new Element.tag('input');
  inputText["type"] = "text";
  inputText["name"] = "test";
  form.appendChild(inputText);
  
  Element inputSubmit = new Element.tag('input');
  inputSubmit["type"] = "submit";
  form.appendChild(inputSubmit);
  
  container.appendChild(form);
  
  rtc.dom.addToBody(container);
  replyTo.send(rtc.toString());
}