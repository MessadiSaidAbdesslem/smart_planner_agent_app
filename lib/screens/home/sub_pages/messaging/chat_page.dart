import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:smart_planner_agent_app/widgets/rounded_rectangle_appbar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  static const id = "/chatpage";

  @override
  Widget build(BuildContext context) {
    String roomId = Get.arguments['roomid'];
    return Scaffold(
      appBar: RRAppBar(Get.arguments['roomname'] as String),
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
                    onAttachmentPressed: () async {
                      ImageSource? sourceValue;
                      await Get.bottomSheet(Container(
                        color: Colors.white,
                        width: 100.w,
                        child: Column(
                          children: [
                            Card(
                              child: ListTile(
                                  title: const Text("Camera"),
                                  onTap: () {
                                    sourceValue = ImageSource.camera;
                                    Get.back();
                                  },
                                  leading: const Icon(Icons.camera_alt)),
                            ),
                            Card(
                              child: ListTile(
                                  title: const Text("Gallery"),
                                  onTap: () {
                                    sourceValue = ImageSource.gallery;
                                    Get.back();
                                  },
                                  leading: const Icon(Icons.image)),
                            )
                          ],
                        ),
                      ));
                      if (sourceValue == null) return;

                      XFile? res =
                          await ImagePicker().pickImage(source: sourceValue!);
                      if (res != null) {
                        Uint8List imageBytes = await res.readAsBytes();
                        var res2 = await FirebaseStorage.instance
                            .ref('images/messages/')
                            .child(roomId)
                            .child(DateTime.now().toString() + res.name)
                            .putData(imageBytes,
                                SettableMetadata(contentType: res.mimeType));
                        res2.ref.getDownloadURL();
                        types.PartialImage imageMessage = types.PartialImage(
                            name: res.name,
                            size: await res.length(),
                            uri: await res2.ref.getDownloadURL());

                        FirebaseChatCore.instance
                            .sendMessage(imageMessage, roomId);
                      }
                    },
                    user: types.User(
                        id: FirebaseChatCore.instance.firebaseUser?.uid ?? ""));
              })),
    );
  }
}
