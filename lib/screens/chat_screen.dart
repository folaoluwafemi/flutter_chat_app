import 'package:chat_app_flutter/models/models.dart';
import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatefulWidget {
  static const String id = '/chat';
  final GroupChatArgument args;

  const ChatScreen({required this.args, Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  bool isPIon = false;
  User? _user;
  String message = '';

  @override
  void initState() {
    _user = _auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String chatName = widget.args.chatName;

    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: const Center(
              child: Text('\u{26A1}Chat'),
            ),
          ),
          body: ModalProgressHUD(
            inAsyncCall: isPIon,
            child: SizedBox(
              height: (MediaQuery.of(context).viewInsets.bottom != 0)
                  ? (constraints.maxHeight - 80) -
                      MediaQuery.of(context).viewInsets.bottom
                  : constraints.maxHeight - 80,
              child: Stack(
                children: [
                  // ListView.builder(
                  //     itemCount: group.messages.length,
                  //     itemBuilder: (context, inx) {
                  //       var message = group.messages[inx];
                  //       return MessageBox(
                  //         message: message,
                  //         isCurrentUser: message.senderEmail == _user!.email!,
                  //       );
                  //     }),

                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _firestore
                        .collection(chatName)
                        .orderBy('timeStamp')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'Error: Firestore stream snapshot has an error'));
                      }
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      List<DocumentSnapshot> newSnapshotList =
                          snapshot.data?.docs ?? [];

                      return SizedBox(
                        height: (MediaQuery.of(context).viewInsets.bottom != 0)
                            ? (constraints.maxHeight - 150) -
                                MediaQuery.of(context).viewInsets.bottom
                            : constraints.maxHeight - 150,
                        child: ListView.builder(
                          itemCount: newSnapshotList.length,
                          itemBuilder: (context, index) {
                            MessageModel newMessage = MessageModel.fromSnapshot(
                                newSnapshotList[index]
                                    as DocumentSnapshot<Map<String, dynamic>>);
                            return MessageBox(
                              message: newMessage,
                              isCurrentUser:
                                  (newMessage.senderEmail == _user!.email!),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(
                                color: Colors.blueAccent, width: 2.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 4,
                            child: MessageField(
                              onTextChanged: (value) {
                                message = value;
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              setState(() {
                                isPIon = true;
                              });

                              var newMessage = MessageModel(
                                  senderEmail: _user!.email!,
                                  messageText: message,
                                  timeStamp: DateTime.now());

                              // await _firestore
                              //     .collection('chats')
                              //     .doc(chatDocumentId)
                              //     .update({
                              //   'groups.messages.${index + 1}': MessageModel.toJson(newMessage),
                              // })
                              // .then((value) => print("user has been updated successfully \n\n\n\n successfully"))
                              // .catchError((error)=> print('user has NOT been updated due to: $error'));

                              await _firestore.collection(chatName).add(
                                    MessageModel.toJson(newMessage),
                                  );
                              setState(() {
                                isPIon = false;
                                _messageController.text = '';
                              });
                            },
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
