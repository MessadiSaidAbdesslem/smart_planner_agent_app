import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:smart_planner_agent_app/screens/home/sub_pages/messaging/chat_page.dart';
import 'package:smart_planner_agent_app/widgets/error_message_widget.dart';

class MessageriePage extends StatelessWidget {
  const MessageriePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
    return StreamBuilder<List<types.Room>>(
      initialData: const [],
      stream: FirebaseChatCore.instance.rooms(),
      builder: (context, snapshot) {
        print(snapshot.data);
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasError) {
            return ErrorMessageWidget(error: snapshot.error.toString());
          }
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.isEmpty) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(
                  bottom: 200,
                ),
                child: const Text('No rooms'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final room = snapshot.data![index];

                return GestureDetector(
                  onTap: () {
                    Get.toNamed(ChatPage.id,
                        arguments: {'roomid': room.id, 'roomname': room.name});
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 1.5.w, horizontal: 5.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        _buildAvatar(room),
                        Text(room.name ?? ''),
                        const Spacer(),
                        Text(DateTime.fromMillisecondsSinceEpoch(
                                room.createdAt ?? 0)
                            .toIso8601String()
                            .substring(0, 10))
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAvatar(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != FirebaseAuth.instance.currentUser!.uid,
        );

        color = getUserAvatarNameColor(otherUser);
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : Colors.black,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  Color getUserAvatarNameColor(types.User user) {
    final index = user.id.hashCode % colors.length;
    return colors[index];
  }
}


// class CustomUser extends User