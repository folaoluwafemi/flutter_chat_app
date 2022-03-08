import 'package:chat_app_flutter/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class DataRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('messages');

  Stream<QuerySnapshot> getStream(){
    return _collection.snapshots();
  }

  Future<DocumentReference> addMessages(MessageModel message) async {
    return await _collection.add(MessageModel.toJson(message));
  }



}