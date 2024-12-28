import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class ChatsViewTile extends StatelessWidget {
  final Chat chat;
  final VoidCallback onClick;
  const ChatsViewTile({super.key, required this.chat, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previous, current) {
          if (current.user != previous.user) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          bool seen = chat.getSeen(state.user!.userId);
          return Padding(
            padding: EdgeInsets.only(left: 2.w, right: 2.w),
            child: Badge(
              isLabelVisible: !seen,
              alignment: Alignment.centerRight,
              backgroundColor: Colors.blue,
              child: SizedBox(
                height: 9.h,
                width: 100.w,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          chat.user1ProfileLoc == state.user!.profileLocation
                              ? (chat.user2ProfileLoc == null
                                  ? const AssetImage('assets/blankprofile.png')
                                  : NetworkImage(chat.user2ProfileLoc!))
                              : (chat.user1ProfileLoc == null
                                  ? const AssetImage('assets/blankprofile.png')
                                  : NetworkImage(chat.user1ProfileLoc!)),
                      backgroundColor: const Color.fromARGB(255, 34, 42, 55),
                      radius: 9.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 3.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 0.7.w),
                            child: SizedBox(
                                width: 40.w,
                                child: Text(
                                  style: TextStyle(
                                      fontSize: 4.4.w,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                  chat.user1UserName == state.user!.userName
                                      ? chat.user2UserName
                                      : chat.user1UserName,
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                          SizedBox(
                              width: 57.w,
                              child: Text(
                                chat.lastMessage,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 3.5.w,
                                    fontWeight: seen
                                        ? FontWeight.w300
                                        : FontWeight.bold,
                                    color: const Color.fromARGB(
                                        215, 255, 255, 255)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ))
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        DateFormat(
                          'hh:mm a',
                        ).format(chat.lastMessageDateTime),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                seen ? FontWeight.w400 : FontWeight.w700,
                            color: seen
                                ? const Color.fromARGB(215, 255, 255, 255)
                                : Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
