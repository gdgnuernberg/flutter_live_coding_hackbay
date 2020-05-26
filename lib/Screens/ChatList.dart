import 'package:chat/Screens/Chat.dart';
import 'package:chat/api/models/RandomUser.dart';
import 'package:chat/api/randomuserapi.dart';
import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart';

class ChatListScreen extends StatefulWidget {
  ChatListScreen({Key key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  void navigateToChat(RandomUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(user: user),
      ),
    );
  }

  Widget buildList(List users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, i) {
        final RandomUser user = RandomUser.fromJson(users[i]);

        return ListTile(
          onTap: () => navigateToChat(user),
          leading: ClipOval(
            child: Hero(
              tag: user.userID,
              child: Image.network(user.profilePic),
            ),
          ),
          title: Text(user.username),
          subtitle: user.lastMessage != null ? Text(user.lastMessage) : null,
          trailing: Text(
            formatDate(
              user.timestampLastMessage,
              [HH, ':', nn],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBody: true,
      appBar: AppBar(
        title: Text('My Chats'),
        centerTitle: true,
      ),
      body: FutureBuilder<List>(
        future: RandomUserAPI().fetchUsers(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot.data);
          } else if (snapshot.hasError) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Error while fetching our users'),
                  Text(
                    snapshot.error.toString(),
                  )
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [const CircularProgressIndicator(), const Text('Loading')],
            ),
          );
        },
      ),
    );
  }
}
