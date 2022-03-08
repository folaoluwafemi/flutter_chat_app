import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

extension Parser on String {
  DateTime dateTimeParser() => DateTime.parse(this);
}

extension Message on List<Map<String, dynamic>> {
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

  factory MessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final newMessage =
        MessageModel.fromJson(snapshot.data() as Map<String, dynamic>);
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

class GroupModel {
  final String name;
  final List<MessageModel> messages;

  GroupModel({
    required this.name,
    required this.messages,
  });

  factory GroupModel.fromSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      GroupModel.fromJson(snapshot.data() as Map<String, dynamic>);

  factory GroupModel.fromJson(Map<String, dynamic> group) =>
      _groupFromJson(group);

  Map<String, dynamic> toJson(GroupModel group) => _groupToJson(group);
}

GroupModel _groupFromJson(Map<String, dynamic> groups) {
  var group = groups['groups'];
  var name = group['name'].toString();
  List<MessageModel> messages = [];

  List<dynamic> firebaseMessage = group['messages'];

  for (var element in firebaseMessage) {
    messages.add(MessageModel.fromJson(Map.from(element)));
  }

  return GroupModel(name: name, messages: messages);
}

Map<String, dynamic> _groupToJson(GroupModel group) {
  String name = group.name;

  List<Map<String, dynamic>> messages = [];

  for (var message in group.messages) {
    messages.add(MessageModel.toJson(message));
  }
  return <String, dynamic>{
    'name': name,
    'messages': messages,
  };
}
