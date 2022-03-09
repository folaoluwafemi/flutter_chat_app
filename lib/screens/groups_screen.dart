import 'package:chat_app_flutter/models/models.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  static const String id = '/group';

  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(child: Text('\u{26A1}Groups')),
          ),
          body: Column(
            children: [
              SizedBox(
                height: constraints.maxHeight - 100,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firestore.collection('chats').snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("there's an error somewhere"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var collection = snapshot.data;
                    List<DocumentSnapshot<Map<String, dynamic>>> documentList =
                        collection?.docs
                            as List<DocumentSnapshot<Map<String, dynamic>>>;

                    return ListView.builder(
                      itemCount: documentList.length,
                      itemBuilder: (context, index) {
                        var document = documentList[index].data();
                        var group = GroupModel.fromJson(
                            document as Map<String, dynamic>);

                        return GroupTile(
                          groupName: group.name,
                          onTapped: () {
                            Navigator.of(context).pushNamed(
                              ChatScreen.id,
                              arguments:
                                  GroupChatArgument(chatName: group.name),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return AddGroupBottomSheet(
                      createGroupCallback: (groupName) =>
                          addNewGroup(groupName),
                    );
                  });
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  void addNewGroup(String name) async {
    var newMessage = MessageModel(
      senderEmail: _user!.email!,
      messageText: 'Welcome to this new group chat',
      timeStamp: DateTime.now(),
    );

    var newGroup = GroupModel(
      name: name,
    );

    var messageModelMap = MessageModel.toJson(newMessage);

    Map<String, dynamic> groups = {
      'groups': GroupModel.toJson(newGroup),
    };
    await _firestore.collection('chats').add(groups);
    await _firestore.collection(name).add(
          messageModelMap,
        );
  }
}
