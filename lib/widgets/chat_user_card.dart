import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_application/api/apis.dart';
import 'package:chatting_application/helper/my_date_util.dart';
import 'package:chatting_application/models/chat_user.dart';
import 'package:chatting_application/models/message.dart';
import 'package:chatting_application/screens/chat_screen.dart';
import 'package:chatting_application/widgets/dialogs/profile_diaglog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // LAST MESSAGE INFO (IF NULL -> NO MESSAGE)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 1,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                //USER PROFILE PHOTO
                leading: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return ProfileDialog(user: widget.user);
                        });
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadiusDirectional.circular(mq.height * .3),
                    child: CachedNetworkImage(
                      height: mq.height * .055,
                      width: mq.height * .055,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),

                //USER NAME
                title: Text(widget.user.name),

                //LAST MESSAGE
                subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'Image'
                            : _message!.msg
                        : widget.user.about,
                    maxLines: 1),

                //LAST MESSAGE TIME
                trailing: _message == null
                    ? null
                    : _message!.read.isNotEmpty &&
                            _message!.fromID != APIs.user.uid
                        ? Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent[400],
                                borderRadius:
                                    BorderRadiusDirectional.circular(20)),
                          )
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54)),
              );
            },
          )),
    );
  }
}
