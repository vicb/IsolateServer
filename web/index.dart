import 'dart:isolate';
import 'package:IsolateServer/CoreApi/coreapi.dart';


void main(List<String> args, SendPort replyTo) {
  Core rtc = new Core(args);
  
  rtc.dom.setTitle("Test IsolateServer");
  rtc.dom.addStyleSheetToHead('/client/resources/css/main.css');
  
  Element containerHelloWorld = new Element.tag('div');
  containerHelloWorld["id"] = "containerhelloworld";
  containerHelloWorld["class"] = 'center';
  
  Element text = new Element.tag('span');  
  text.innerText ="Hello World !";
  containerHelloWorld.appendChild(text);
  
  rtc.dom.appendToBody(containerHelloWorld);
  
  Element containerText = new Element.tag('div');
  containerText["id"] = "containerText";
  containerText["class"] = "center";
  
  Element spanText = new Element.tag('span');
  spanText.innerText = "This page is fully written in dart !";
  containerText.appendChild(spanText);
  
  rtc.dom.appendToBody(containerText);
  
  Element scriptMain = new Element.tag('script');
  scriptMain["src"] = '/client/resources/dart/test.dart';
  scriptMain["type"] = 'application/dart';
  rtc.dom.appendToBody(scriptMain);  
  Element scriptDart = new Element.tag('script');
  scriptDart["src"] = '/packages/browser/dart.js';
  scriptDart["type"] = 'text/javascript';
  rtc.dom.appendToBody(scriptDart);
    
  replyTo.send(rtc.toString());
}