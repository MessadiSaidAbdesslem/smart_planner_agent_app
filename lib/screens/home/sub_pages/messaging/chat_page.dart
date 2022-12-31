import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const id = "/chatpage";

  @override
  Widget build(BuildContext context) {
    String roomId = Get.arguments['roomid'];
    return Scaffold(
      appBar: AppBar(title: Text(Get.arguments['roomname'] as String)),
      body: StreamBuilder<types.Room>(
          stream: FirebaseChatCore.instance.room(roomId),
          builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
              stream: FirebaseChatCore.instance.messages(snapshot.data ??
                  const types.Room(
                      id: "aaaaa", type: types.RoomType.group, users: [])),
              initialData: const [],
              builder: (context, snapshot) {
                return Chat(
                    avatarBuilder: (id) {
                      return FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(id)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data!.data()!['imageUrl']),
                              );
                            }
                            return const CircularProgressIndicator();
                          });
                    },
                    showUserNames: true,
                    nameBuilder: (id) {
                      return FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(id)
                              .get(),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              return Text(
                                snapshot.data?.data()?['displayName'] ?? "N/A",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              );
                            }

                            return const Text("User");
                          }));
                    },
                    messages: snapshot.data ?? [],
                    onSendPressed: (message) {
                      FirebaseChatCore.instance.sendMessage(message, roomId);
                    },
                    user: types.User(
                        id: FirebaseChatCore.instance.firebaseUser?.uid ?? ""));
              })),
    );
  }
}
