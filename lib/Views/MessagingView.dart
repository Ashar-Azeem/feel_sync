import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_sync/Models/Message.dart';
import 'package:feel_sync/Utilities/ReusableUI/CustomAvatar.dart';
import 'package:feel_sync/Views/EmotionsAnalysis.dart';
import 'package:feel_sync/bloc/MessagesBloc/messages_bloc.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

class MessagingView extends StatefulWidget {
  const MessagingView({super.key});

  @override
  State<MessagingView> createState() => _MessagingViewState();
}

class _MessagingViewState extends State<MessagingView> {
  Message? currentMessage;
  Message? previousMessage;
  TextEditingController message = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessagesBloc>().add(DisposeSeen());
      final messageState = context.read<MessagesBloc>().state;
      if (messageState.chat!.chatId != null) {
        context.read<MessagesBloc>().add(SeenChecker());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessagesBloc, MessagesState>(
      listenWhen: (previous, current) =>
          current.chat!.chatId != previous.chat!.chatId,
      listener: (context, state) {
        if (state.chat!.chatId != null) {
          context.read<MessagesBloc>().add(SeenChecker());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            BlocBuilder<MessagesBloc, MessagesState>(
              buildWhen: (previous, current) => false,
              builder: (context, state) {
                return IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: EmotionAnalysis(
                          chat: state.chat!,
                          receiverNumber: state.receiverNumber,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.slideUp,
                      );
                    },
                    icon: const Icon(Icons.bar_chart));
              },
            )
          ],
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: Container(
              color: const Color.fromARGB(255, 29, 36, 49),
              height: 0.5,
            ),
          ),
          forceMaterialTransparency: true,
          titleSpacing: 0.0,
          title: BlocBuilder<MessagesBloc, MessagesState>(
            buildWhen: (previous, current) {
              return ((previous.chat!.user1UserName !=
                      current.chat!.user1UserName) ||
                  (previous.chat!.user2UserName !=
                      current.chat!.user2UserName));
            },
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<MessagesBloc, MessagesState>(
                    builder: (context, state) {
                      return CustomAvatar(
                        radius: 1.6.w,
                        url: (state.receiverNumber == 1)
                            ? state.chat!.user1ProfileLoc
                            : state.chat!.user2ProfileLoc,
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: SizedBox(
                      width: 50.w,
                      child: Text(
                          (state.receiverNumber == 1)
                              ? state.chat!.user1UserName
                              : state.chat!.user2UserName,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 251, 250, 250))),
                    ),
                  )
                ],
              );
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<MessagesBloc, MessagesState>(
                buildWhen: (previous, current) {
                  return previous.chat!.chatId != current.chat!.chatId;
                },
                builder: (context, state) {
                  return Align(
                    alignment: state.chat!.chatId == null
                        ? Alignment.center
                        : Alignment.bottomCenter,
                    child: ListView(
                      reverse: true,
                      shrinkWrap: true,
                      children: [
                        BlocBuilder<MessagesBloc, MessagesState>(
                          buildWhen: (previous, current) {
                            return previous.seen != current.seen;
                          },
                          builder: (context, state) {
                            return state.seen == true
                                ? Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 5.w),
                                      child: const Text('Seen'),
                                    ))
                                : const SizedBox.shrink();
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 2.w, left: 0.w, right: 2.w),
                            child: BlocBuilder<MessagesBloc, MessagesState>(
                              buildWhen: (previous, current) {
                                return current.chat!.chatId !=
                                    previous.chat!.chatId;
                              },
                              builder: (context, state) {
                                return state.chat!.chatId == null
                                    ? const Center(child: Text("No messages"))
                                    : FirestorePagination(
                                        limit: 15,
                                        shrinkWrap: true,
                                        reverse: true,
                                        viewType: ViewType.list,
                                        onEmpty: const Center(
                                            child: Text("No messages")),
                                        bottomLoader: const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        isLive: true,
                                        query: FirebaseFirestore.instance
                                            .collection('messages')
                                            .where('chatId',
                                                isEqualTo: state.chat!.chatId)
                                            .orderBy('time', descending: true),
                                        itemBuilder: (context, data, index) {
                                          previousMessage = currentMessage;
                                          currentMessage =
                                              Message.fromDocumentSnapshot(
                                                  data.elementAt(index));
                                          if (index == 0) {
                                            previousMessage = null;
                                            if (currentMessage!.senderUserId !=
                                                FirebaseAuth.instance
                                                    .currentUser!.uid) {
                                              //Update the chat as read from this user
                                              context
                                                  .read<MessagesBloc>()
                                                  .add(MessageSeenAction());
                                            }
                                          }

                                          if (currentMessage!.senderUserId ==
                                              state.chat!.getUserId(
                                                  state.receiverNumber)) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1.h),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        previousMessage !=
                                                                    null &&
                                                                currentMessage!
                                                                        .senderUserId ==
                                                                    previousMessage!
                                                                        .senderUserId
                                                            ? SizedBox(
                                                                width: 11.w,
                                                              )
                                                            : Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 1.5
                                                                            .w,
                                                                        right: 1.5
                                                                            .w),
                                                                child: BlocBuilder<
                                                                    MessagesBloc,
                                                                    MessagesState>(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return CustomAvatar(
                                                                      radius:
                                                                          0.8.w,
                                                                      url: state.receiverNumber == 1
                                                                          ? state
                                                                              .chat!
                                                                              .user1ProfileLoc
                                                                          : state
                                                                              .chat!
                                                                              .user2ProfileLoc,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                        ChatBubble(
                                                          backGroundColor:
                                                              const Color
                                                                  .fromARGB(255,
                                                                  66, 74, 100),
                                                          elevation: 0,
                                                          shadowColor: null,
                                                          clipper: previousMessage !=
                                                                      null &&
                                                                  (currentMessage!
                                                                          .senderUserId ==
                                                                      previousMessage!
                                                                          .senderUserId)
                                                              ? ChatBubbleClipper5(
                                                                  type: BubbleType
                                                                      .receiverBubble)
                                                              : ChatBubbleClipper4(
                                                                  type: BubbleType
                                                                      .receiverBubble),
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        70.w),
                                                            child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      bottom:
                                                                          6.w,
                                                                      right: currentMessage!.content.length <
                                                                              25
                                                                          ? 8.w
                                                                          : 0),
                                                                  child: Text(
                                                                    currentMessage!
                                                                        .content,
                                                                    softWrap:
                                                                        true,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  right: 0,
                                                                  child: Text(
                                                                    DateFormat(
                                                                      'hh:mm a',
                                                                    ).format(
                                                                        currentMessage!
                                                                            .time),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w200),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                previousMessage != null &&
                                                        !isSameDay(
                                                            previousMessage!
                                                                .time,
                                                            currentMessage!
                                                                .time)
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2.h,
                                                                bottom: 2.h),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              DateFormat
                                                                      .MMMMEEEEd()
                                                                  .format(
                                                                      currentMessage!
                                                                          .time),
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          188,
                                                                          188,
                                                                          191))),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            );
                                          } else {
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1.h),
                                                  child: ChatBubble(
                                                    backGroundColor:
                                                        const Color.fromARGB(
                                                            255, 7, 108, 148),
                                                    elevation: 0,
                                                    shadowColor: null,
                                                    clipper: previousMessage !=
                                                                null &&
                                                            (currentMessage!
                                                                    .senderUserId ==
                                                                previousMessage!
                                                                    .senderUserId)
                                                        ? ChatBubbleClipper5(
                                                            type: BubbleType
                                                                .sendBubble)
                                                        : ChatBubbleClipper3(
                                                            type: BubbleType
                                                                .sendBubble),
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 75.w),
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: 6.w,
                                                                right: currentMessage!
                                                                            .content
                                                                            .length <
                                                                        25
                                                                    ? 8.w
                                                                    : 0),
                                                            child: Text(
                                                              currentMessage!
                                                                  .content,
                                                              softWrap: true,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                              'hh:mm a',
                                                            ).format(
                                                                currentMessage!
                                                                    .time),
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w200),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                previousMessage != null &&
                                                        !isSameDay(
                                                            previousMessage!
                                                                .time,
                                                            currentMessage!
                                                                .time)
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 2.h,
                                                                bottom: 2.h),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              DateFormat
                                                                      .MMMMEEEEd()
                                                                  .format(
                                                                      currentMessage!
                                                                          .time),
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          188,
                                                                          188,
                                                                          191))),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            );
                                          }
                                        },
                                      );
                              },
                            ))
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        color: const Color.fromARGB(255, 37, 42, 57)),
                    alignment: Alignment.center,
                    width: 96.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(1.w),
                            child: BlocBuilder<UserBloc, UserState>(
                              buildWhen: (previous, current) =>
                                  previous.user!.profileLocation !=
                                  current.user!.profileLocation,
                              builder: (context, state) {
                                return CustomAvatar(
                                  radius: 1.5.w,
                                  url: state.user!.profileLocation,
                                );
                              },
                            )),
                        Padding(
                          padding: EdgeInsets.only(left: 3.w, right: 0),
                          child: SizedBox(
                            width: 65.w,
                            child: TextField(
                              onChanged: (value) {
                                context
                                    .read<MessagesBloc>()
                                    .add(ButtonVisibility(text: value));
                              },
                              maxLines: 5,
                              expands: false,
                              minLines: 1,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
                              controller: message,
                              autocorrect: false,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Message...'),
                            ),
                          ),
                        ),
                        BlocBuilder<MessagesBloc, MessagesState>(
                          buildWhen: (previous, current) =>
                              previous.sendMessageLoading !=
                                  current.sendMessageLoading ||
                              previous.buttonVisibility !=
                                  current.buttonVisibility,
                          builder: (context, state) {
                            return GestureDetector(
                                onTap: () {
                                  if (message.text.trim().isNotEmpty) {
                                    context.read<MessagesBloc>().add(
                                        SendMessage(
                                            messageText: message.text.trim()));
                                    message.text = '';
                                    context.read<MessagesBloc>().add(
                                        ButtonVisibility(text: message.text));
                                  }
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: state.sendMessageLoading
                                            ? 5.w
                                            : 2.w),
                                    child: state.sendMessageLoading
                                        ? const CupertinoActivityIndicator(
                                            color: Colors.blue,
                                          )
                                        : state.buttonVisibility
                                            ? Container(
                                                width: 10.w,
                                                height: 10.w,
                                                decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.send,
                                                    color: Colors.white,
                                                    size: 5.w,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink()));
                          },
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
