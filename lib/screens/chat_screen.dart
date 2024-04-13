import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatting_application/helper/my_date_util.dart';
import 'package:chatting_application/screens/view_profile_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // FOR SHORTING ALL MESSAGES
  List<Message> _messageList = [];

  // FOR HANDLING MESSAGE TEXT CHANGES
  final _messageController = TextEditingController();

  // FOR STORING VALUE OF SHOWING OR HIDING EMOJI
  bool _showEmoji = false;

  // FOR CHECKING IF IMAGE IS UPLOADING OR NOT?
  bool _isUploading = false;

  // Pick an image.
  final ImagePicker picker = ImagePicker();

  // PICKED IMAGE PATH
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    // FOR CHANGING STATUS BAR COLOR
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.teal, // Set status bar color here
        statusBarIconBrightness: Brightness.light, // Set status bar icons color
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: WillPopScope(
            // IF EMOJI ARE SHOWN AND BACK BUTTON IS PRESSED THE HIDE EMOJI
            // OR ELSE SIMPLY CLOSE THE CURRENT SCREEN ON BACK BUTTON CLICK
            onWillPop: () async {
              if (_showEmoji) {
                setState(() {
                  _showEmoji = !_showEmoji;
                });
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Scaffold(
              // APP BAR
              appBar: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: _appBar(),
                actions: [
                  // VIDEO CALLING BUTTON
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.video_call_rounded),
                  ),

                  // CALLING BUTTON
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                  ),

                  // MORE BUTTON
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              backgroundColor: Colors.teal[100],
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //IF DATA IS LOADING
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(child: SizedBox());

                          // IF SOME OR ALL DATA IS LOADED THEN SHOW IT
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            // log('Data: ${jsonEncode(data![0].data())}');
                            _messageList = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_messageList.isNotEmpty) {
                              return ListView.builder(
                                reverse: true,
                                padding: EdgeInsets.only(top: mq.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemCount: _messageList.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: _messageList[index],
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Say Hii...👋',
                                    style: TextStyle(fontSize: 20)),
                              );
                            }
                        }
                      },
                    ),
                  ),

                  // CircularProgressIndicator WHILE UPLOADING IMAGE
                  if (_isUploading)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 1),
                      ),
                    ),
                  _chatInput(),

                  // EMOJI WIDGET
                  if (_showEmoji)
                    SizedBox(
                      height: mq.height * .34,
                      child: EmojiPicker(
                        // onEmojiSelected: (Category category, Emoji emoji) {
                        //   // Do something when emoji is tapped (optional)
                        // },
                        // onBackspacePressed: () {
                        //   // Do something when the user taps the backspace button (optional)
                        // },
                        textEditingController: _messageController,
                        // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                        config: Config(
                          columns: 8,
                          emojiSizeMax: 32 *
                              (foundation.defaultTargetPlatform ==
                                      TargetPlatform.iOS
                                  ? 1.30
                                  : 1.0),
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          gridPadding: EdgeInsets.zero,
                          initCategory: Category.RECENT,
                          // bgColor: Colors.teal.shade100,
                          // indicatorColor: Colors.blue,
                          // iconColor: Colors.grey,
                          // iconColorSelected: Colors.blue,
                          // backspaceColor: Colors.blue,
                          // skinToneDialogBgColor: Colors.white,
                          // skinToneIndicatorColor: Colors.grey,
                          // enableSkinTones: true,
                          // showRecentsTab: true,
                          recentsLimit: 28,
                          noRecents: const Text(
                            'No Resents',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black26),
                            textAlign: TextAlign.center,
                          ),
                          // Needs to be const Widget
                          loadingIndicator: const SizedBox.shrink(),
                          // Needs to be const Widget
                          tabIndicatorAnimDuration: kTabScrollDuration,
                          categoryIcons: const CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // APP BAR WIDGET
  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserStatus(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
              children: [
                // BACK BUTTON
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),

                // USER PROFILE PICTURE
                ClipRRect(
                  borderRadius:
                      BorderRadiusDirectional.circular(mq.height * .1),
                  child: CachedNetworkImage(
                    height: mq.height * .05,
                    width: mq.height * .05,
                    fit: BoxFit.cover,
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),

                // FOR ADDING SOME SPACE
                SizedBox(width: mq.width * .03),

                // USER NAME & LAST SEEN TIME
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // USER NAME
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black87),
                    ),

                    // LAST SEEN TIME
                    Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'Online'
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 13)),
                  ],
                ),
              ],
            );
          },
        ));
  }

  // MESSAGE TYPING WIDGET (BOTTOM CHAT INPUT FIELD)
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .02, vertical: mq.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Row(
                children: [
                  // EMOJI BUTTON
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions),
                    color: Colors.teal,
                  ),
                  // MESSAGE INPUT
                  Expanded(
                    child: TextFormField(
                      controller: _messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) {
                          setState(() => _showEmoji = !_showEmoji);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Type Something,....',
                        hintStyle: TextStyle(color: Colors.teal[200]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //PICK IMAGE FROM GALLERY BUTTON
                  IconButton(
                    onPressed: () async {
                      // PICK MULTIPLE IMAGES
                      final List<XFile?> images = await picker.pickMultiImage();
                      if (images.isNotEmpty) {
                        setState(() => _isUploading = true);

                        // UPLOADING AND SENDING IMAGES ONE BY ONE
                        for (var i in images) {
                          if (mounted) {
                            await APIs.sendChatImage(
                                widget.user, File(i!.path));
                            setState(() => _isUploading = false);
                          }
                        }

                        // if (i != null) {
                        //   setState(() {
                        //     _imagePath = i.path;
                        //   });
                        //   if (mounted) {
                        //     APIs.sendChatImage(widget.user, File(_imagePath!));
                        //     // Navigator.pop(context);
                        //   }
                        // }
                      }
                    },
                    icon: const Icon(Icons.image),
                    color: Colors.teal,
                  ),

                  //CAPTURE IMAGE FROM CAMERA BUTTON
                  IconButton(
                    onPressed: () async {
                      // Capture a photo.
                      final XFile? photo =
                          await picker.pickImage(source: ImageSource.camera);
                      if (photo != null) {
                        setState(() =>
                            // _imagePath = photo.path;
                            _isUploading = true);
                        if (mounted) {
                          await APIs.sendChatImage(
                              widget.user, File(_imagePath!));
                          setState(() => _isUploading = false);
                        }
                      }
                    },
                    icon: const Icon(Icons.camera_alt_rounded),
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ),

          // SEND MESSAGE BUTTON
          MaterialButton(
            shape: const CircleBorder(),
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 05),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                APIs.sendMessage(
                    widget.user, _messageController.text, Type.text);
                _messageController.text = '';
              }
            },
            color: Colors.green,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
