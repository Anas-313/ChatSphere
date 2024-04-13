import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_application/models/chat_user.dart';
import 'package:chatting_application/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(mq.height * .02)),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .35,
        child: Stack(
          children: [
            // USER NAME
            Positioned(
              top: mq.height * .02,
              left: mq.width * .03,
              child: Text(user.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500)),
            ),

            // USER PROFILE PICTURE
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: mq.height * .2,
                  height: mq.height * .2,
                  imageUrl: user.image,
                ),
              ),
            ),

            // INFO ICON
            Positioned(
              top: mq.height * .01,
              right: mq.width * .01,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewProfileScreen(user: user)),
                  );
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 30,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
