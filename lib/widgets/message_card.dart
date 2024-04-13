import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_application/api/apis.dart';
import 'package:chatting_application/helper/my_date_util.dart';
import 'package:chatting_application/models/message.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromID
        ? _greenMessage()
        : _blueMessage();
  }

  // SEND MESSAGE
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // ADDING SOME SPACE
            SizedBox(width: mq.width * .03),

            // DOUBLE TICK BLUE ICON FOR READ MESSAGE
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            // DOUBLE TICK ICON FOR RECEIVED MESSAGE
            if (widget.message.read.isEmpty)
              const Icon(Icons.done_all_rounded, size: 20),

            // ADDING SOME SPACE
            SizedBox(width: mq.width * .01),

            // MESSAGE TIME
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        // MESSAGE CONTENT
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? (mq.width * .03)
                : (mq.width * .04)),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color(0xFFE0FDFD),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                border: Border.all(color: Colors.teal)),
            child: widget.message.type == Type.text
                ?
                // SHOW TEXT MESSAGE
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )
                : ClipRRect(
                    borderRadius:
                        BorderRadiusDirectional.circular(mq.height * .01),
                    child: CachedNetworkImage(
                      height: mq.height * .4,
                      width: mq.height * .3,
                      fit: BoxFit.cover,
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(Icons.image, size: 70)),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // RECEIVED MESSAGE
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateReadMessageStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // MESSAGE CONTENT
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? (mq.width * .03)
                : (mq.width * .04)),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .01),
            decoration: BoxDecoration(
                color: const Color(0xFFCCE5FF),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                border: Border.all(color: const Color(0xFF006666))),
            child: widget.message.type == Type.text
                ?
                // SHOW TEXT MESSAGE
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  )
                // SHOW IMAGE
                : ClipRRect(
                    borderRadius:
                        BorderRadiusDirectional.circular(mq.height * .01),
                    child: CachedNetworkImage(
                      height: mq.height * .4,
                      width: mq.height * .3,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(strokeWidth: 2),
                      imageUrl: widget.message.msg,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(Icons.image, size: 70)),
                    ),
                  ),
          ),
        ),

        // MESSAGE TIME
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        )
      ],
    );
  }
}
