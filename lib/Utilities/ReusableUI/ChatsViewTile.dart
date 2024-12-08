import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChatsViewTile extends StatelessWidget {
  final Chat chat;
  const ChatsViewTile({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // PersistentNavBarNavigator.pushNewScreen(
        //   context,
        //   screen: VisitingUserView(hostUser: user),
        //   withNavBar: true,
        //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
        // );
      },
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previous, current) {
          if (current.user != previous.user) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(left: 4.w, right: 2.w),
            child: SizedBox(
              height: 10.h,
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
                          padding: EdgeInsets.only(bottom: 1.w),
                          child: SizedBox(
                              width: 40.w,
                              child: Text(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
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
                              style: TextStyle(fontSize: 3.w),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.message_outlined,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
