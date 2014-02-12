import 'dart:isolate';
import 'package:IsolateServer/CoreApi/coreapi.dart';


void main(List<String> args, SendPort replyTo) {
  Core rtc = new Core(args);
  
  rtc.dom.setTitle("Test IsolateServer");
  rtc.dom.addStyleSheetToHead('/resources/css/main.css');
  
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
  
  rtc.dom.addScriptToHead('/resources/dart/test.dart', 'application/dart');
  rtc.dom.addScriptToHead('/packages/browser/dart.js', 'text/javascript');
    
  replyTo.send(rtc.toString());
}