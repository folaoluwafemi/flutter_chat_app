import 'package:chat_app_flutter/models/models.dart';
import 'package:chat_app_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

class RoundEdgeButton extends StatelessWidget {
  final VoidCallback? buttonOnPressed;
  final Widget? child;
  final EdgeInsets? padding;
  final Color? color;

  const RoundEdgeButton(
    this.buttonOnPressed, {
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 16.0),
    @required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Material(
        elevation: 5.0,
        color: color!,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          minWidth: 200,
          height: 42,
          child: child!,
          onPressed: buttonOnPressed!,
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  final bool? isPassword;
  final String? hintTitle;
  final BoxConstraints? constraints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool? isEmail;

  const AuthTextField({
    @required this.onChanged,
    this.onSubmitted,
    @required this.hintTitle,
    this.constraints,
    this.isPassword,
    this.isEmail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: TextFormField(
            keyboardType: (isEmail == null) ? null : TextInputType.emailAddress,
            obscureText: isPassword ?? false,
            textAlign: TextAlign.center,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            cursorHeight: 20,
            decoration: authInputDecoration().copyWith(hintText: hintTitle)),
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  final ValueChanged? onTextChanged;

  MessageField({Key? key, @required this.onTextChanged}) : super(key: key);

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: TextField(
        controller: _messageController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type your message here...',
        ),
        onChanged: onTextChanged,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
      ),
    );
  }
}

class MessageBox extends StatelessWidget {
  final bool isCurrentUser;
  final MessageModel message;

  const MessageBox(
      {required this.message, required this.isCurrentUser, Key? key})
      : super(key: key);

  final double borderRadius = 30;
  final formattedTime = TimeOfDayFormat.HH_colon_mm;

  String timeFormatter() {
    var rawTime = message.timeStamp;
    var now = DateTime.now();
    var newTime = now.difference(rawTime);
    var minuteTime = newTime.inMinutes;
    var hourTime = newTime.inHours;

    return hourTime.toString() + ':' + minuteTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 8, left: 8),
      child: Column(
        crossAxisAlignment:
            (isCurrentUser) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(message.senderEmail, style: messageStyle()),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Text(
                    message.messageText,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            padding:
                const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 10),
            decoration: BoxDecoration(
              color: (isCurrentUser)
                  ? Colors.blueAccent.withOpacity(0.5)
                  : Colors.orange.withOpacity(0.5),
              borderRadius: (isCurrentUser)
                  ? BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      topLeft: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      topLeft: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius),
                    ),
            ),
          ),
          Chip(
            label: Text(
              timeFormatter(),
              style: messageStyle(),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupTile extends StatelessWidget {
  final String groupName;
  final VoidCallback onTapped;

  const GroupTile({required this.groupName, required this.onTapped, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      child: InkWell(
        onTap: onTapped,
        child: ListTile(
          tileColor: Colors.orange.withOpacity(0.5),
          leading: CircleAvatar(
            child: Image.asset('images/chat_logo.png'),
          ),
          title: Text(
            groupName,
          ),
        ),
      ),
    );
  }
}

class AddGroupTextField extends StatelessWidget {
  final ValueChanged valueChanged;
  final String? hintText;

  const AddGroupTextField(
      {required this.valueChanged, required this.hintText, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        onChanged: valueChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class AddGroupBottomSheet extends StatefulWidget {
  final Function(String name) createGroupCallback;

  const AddGroupBottomSheet({required this.createGroupCallback,  Key? key})
      : super(key: key);

  @override
  State<AddGroupBottomSheet> createState() => _AddGroupBottomSheetState();
}

class _AddGroupBottomSheetState extends State<AddGroupBottomSheet> {
  String groupName = '';

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              AddGroupTextField(
                valueChanged: (value) {
                  groupName = value;
                },
                hintText: 'Group Name...',
              ),
              const SizedBox(
                height: 19,
              ),
              ElevatedButton(
                onPressed: () {
                  widget.createGroupCallback(groupName);
                  Navigator.of(context).pop();
                },
                child: const Text('Create Group'),
              ),
            ],
          ),
        );
      },
    );
  }
}
