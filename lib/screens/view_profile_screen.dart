import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_application/helper/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/chat_user.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // FOR HIDING KEYBOARD WHEN A TAP IS DETECTED ON SCREEN
      onTap: () => FocusScope.of(context).unfocus(),
      // FOR HIDING KEYBOARD
      child: Scaffold(
        //APP BAR
        appBar: AppBar(
          title: Text(widget.user.name),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Joined On :',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            Text(
              MyDateUtil.getLastMessageTime(
                  context: context,
                  time: widget.user.createdAt,
                  showYear: true),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),

        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // FOR ADDING SPACE
                SizedBox(height: mq.height * .03, width: mq.width),

                //USER PROFILE PHOTO
                ClipRRect(
                  borderRadius:
                      BorderRadiusDirectional.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    height: mq.height * .2,
                    width: mq.height * .2,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                // FOR ADDING SPACE
                SizedBox(height: mq.height * .03, width: mq.width),

                // USER EMAIL ID
                Text(widget.user.email,
                    style:
                        const TextStyle(color: Colors.black54, fontSize: 18)),

                // FOR ADDING SPACE
                SizedBox(height: mq.height * .05, width: mq.width),

                // USER ABOUT FIELD
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'About :',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    Text(widget.user.about,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
