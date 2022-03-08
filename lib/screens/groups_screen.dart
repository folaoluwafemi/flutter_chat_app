import 'package:chat_app_flutter/models/models.dart';
import 'package:chat_app_flutter/screens/chat_screen.dart';
import 'package:chat_app_flutter/utils/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  static const String id = '/group';

  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
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

                    List<DocumentSnapshot<Map<String, dynamic>>> documentList =
                        snapshot.data?.docs
                            as List<DocumentSnapshot<Map<String, dynamic>>>;

                    var documentEntry = GroupModel.fromJson(
                        documentList[0].data() as Map<String, dynamic>);

                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        var group = documentEntry;
                        print(group.name);
                        return GroupTile(
                          groupName: group.name,
                          ontapped: () {
                            Navigator.of(context).pushNamed(ChatScreen.id);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
