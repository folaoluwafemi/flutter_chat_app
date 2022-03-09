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
  map['timeStamp'] = Timestamp.fromDate(message.timeStamp);

  return map;
}

class GroupModel {
  final String name;

  GroupModel({
    required this.name,
  });


  factory GroupModel.fromSnapshot(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      GroupModel.fromJson(snapshot.data() as Map<String, dynamic>);



  factory GroupModel.fromJson(Map<String, dynamic> group) =>
      _groupFromJson(group);



  static Map<String, dynamic> toJson(GroupModel group) => _groupToJson(group);
}




//converts firebase storable file into group
GroupModel _groupFromJson(Map<String, dynamic> groups) {
  var group = groups['groups'];
  var name = group['name'].toString();

  return GroupModel(name: name);
}



//converts group to firebase storable file
Map<String, dynamic> _groupToJson(GroupModel group) {
  return <String, dynamic>{
    'name': group.name,
  };
}



class GroupChatArgument {
  final String chatName;

  GroupChatArgument({required this.chatName});
}
