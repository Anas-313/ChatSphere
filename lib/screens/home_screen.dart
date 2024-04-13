import 'package:chatting_application/screens/profile_screen.dart';
import 'package:chatting_application/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //FOR STORING ALL USERS
  List<ChatUser> _list = [];

  // FOR STORING SEARCHED USERS
  final List<ChatUser> _searchList = [];

  // FOR STORING SEARCH STATUS
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    // FOR UPDATING USER ACTIVE STATUS ACCORDING TO LIFECYCLE EVENT
    // RESUME -> ACTIVE OR ONLINE
    // PAUSE -> INACTIVE OR OFFLINE
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (APIs.fAuth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // FOR HIDING KEYBOARD WHEN A TAP IS DETECTED ON SCREEN
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
          //APP BAR
          appBar: AppBar(
            title: _isSearching
                ? TextField(
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    decoration: const InputDecoration(
                        hintText: 'Name, Email,...', border: InputBorder.none),
                    //WHEN SEARCH TEXT CHANGES UPDATE THE SEARCHED LIST
                    onChanged: (val) {
                      // SEARCH LOGIC
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                  )
                : const Text('ChatSphere'),
            leading: const Icon(CupertinoIcons.home),
            actions: [
              // SEARCH USER  BUTTON
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),

              // MORE FEATURE BUTTON
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(user: APIs.me)));
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),

          //FLOATING BUTTON FOR ADDING NEW USER
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {},
              // backgroundColor: Colors.lightGreen,
              child: const Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //IF DATA IS LOADING
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                // IF SOME OR ALL DATA IS LOADED THEN SHOW IT
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
              }

              if (_list.isNotEmpty) {
                return ListView.builder(
                  padding: EdgeInsets.only(top: mq.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _isSearching ? _searchList.length : _list.length,
                  itemBuilder: (context, index) {
                    return ChatUserCard(
                        user: _isSearching ? _searchList[index] : _list[index]);
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No Connections found',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

// @override
// void didChangeDependencies() {
//   super.didChangeDependencies();
//   ModalRoute.of(context)?.addScopedWillPopCallback(_handlePop);
// }
//
// Future<bool> _handlePop() async {
//   if (_isSearching) {
//     setState(() {
//       _isSearching = false;
//     });
//     return false;
//   }
//   return true;
// }
}
