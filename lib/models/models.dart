import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

extension on String {
  DateTime dateTimeParser() => DateTime.parse(this);
}

extension Message on List<Map<String, dynamic>>{
  addMessage(MessageModel message) => add(MessageModel.toJson(message));
}

class MessageModel {
  final String messageText;
  final String senderEmail;
  final DateTime timeStamp;

  MessageModel({
    required this.senderEmail,
    required this.messageText,
    required this.timeStamp,
  });

  static MessageModel fromJson(Map<String, dynamic> json) =>
      _messageModelFromJson(json);

  static Map<String, dynamic> toJson(MessageModel message) =>
      _messageModelToJson(message);

  factory MessageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    final newMessage = MessageModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return newMessage;
  }

}

MessageModel _messageModelFromJson(Map<String, dynamic> json) {
  return MessageModel(
    senderEmail: json['email'],
    messageText: json['messageText'],
    timeStamp: json['timeStamp'].toDate(),
  );
}

Map<String, dynamic> _messageModelToJson(MessageModel message) {
  var map = <String, dynamic>{};

  map['email'] = message.senderEmail;
  map['messageText'] = message.messageText;
  map['timeStamp'] = message.timeStamp.toString();

  return map;
}
