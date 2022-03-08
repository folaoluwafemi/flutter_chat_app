import 'package:flutter/material.dart';
import '../models/models.dart';


TextStyle messageStyle(){
  return const TextStyle(fontSize: 12, color: Colors.black54, );
}


InputBorder outlinedTextInput(){
  return OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: Colors.blueAccent),
    borderRadius: BorderRadius.circular(30),
  );
}

InputDecoration authInputDecoration(){
  return InputDecoration(
    border: outlinedTextInput(),
    enabledBorder: outlinedTextInput(),
  );
}

List<MessageModel> convertToMessage(List<dynamic> messageMap){
  var messages = <MessageModel>[];

  for(var jsonMessage in messageMap){
    messages.add(MessageModel.fromJson(jsonMessage as Map<String, dynamic>));
  }
  return messages;
}

List<Map<String, dynamic>> convertFromMessage(List<MessageModel> messages){
  List<Map<String, dynamic>> jsonMessages = [];

  for (var element in messages) {
    jsonMessages.addMessage(element);
  }
  return jsonMessages;
}