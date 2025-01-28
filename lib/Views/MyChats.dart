import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Utilities/ReusableUI/ChatsViewTile.dart';
import 'package:feel_sync/Utilities/ReusableUI/ShimmerLoaderExploreView.dart';
import 'package:feel_sync/Views/MessagingView.dart';
import 'package:feel_sync/bloc/ChatsBloc/chats_bloc.dart';
import 'package:feel_sync/bloc/MessagesBloc/messages_bloc.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

class MyChatsView extends StatefulWidget {
  const MyChatsView({super.key});

  @override
  State<MyChatsView> createState() => _MyChatsViewState();
}

class _MyChatsViewState extends State<MyChatsView> {
  late TextEditingController search;
  @override
  void initState() {
    super.initState();
    search = TextEditingController();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            forceMaterialTransparency: true,
            backgroundColor: Colors.transparent,
            title: Padding(
              padding: EdgeInsets.only(left: 2.w, top: 4.w),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 2, 93, 205),
                      Color.fromARGB(255, 155, 225, 250),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcIn,
                child: Text(
                  "FeelSync",
                  style: GoogleFonts.getFont('League Spartan',
                      textStyle: TextStyle(
                          fontSize: 9.w,
                          color: const Color.fromARGB(255, 8, 152, 204),
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 3.h),
              child: Container(
                width: 75.w,
                height: 5.6.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: const Color.fromARGB(255, 34, 42, 55)),
                child: TextField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    if (search.text.isEmpty) {
                      context.read<ChatsBloc>().add(SearchEnded());
                    } else {
                      context.read<ChatsBloc>().add(SearchChat(
                          ownerUserId: AuthService().getUser()!.uid,
                          otherUserName: search.text));
                    }
                  },
                  cursorColor: Colors.white,
                  enableSuggestions: true,
                  autocorrect: false,
                  controller: search,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search)),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: BlocBuilder<ChatsBloc, ChatsState>(
            buildWhen: (previous, current) {
              if (previous.searchedChat != current.searchedChat ||
                  previous.searching != current.searching ||
                  previous.searchingState != current.searchingState) {
                return true;
              } else {
                return false;
              }
            },
            builder: (context, state) {
              if (state.searching == Searching.no) {
                return FirestorePagination(
                  limit: 15,
                  bottomLoader: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  isLive: true,
                  onEmpty: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: SizedBox(
                        width: 80.w,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                "You don't have any chats yet! Head over to the ",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16, height: 1.3),
                            children: [
                              TextSpan(
                                text: "Explore",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    final userBloc =
                                        context.read<UserBloc>().state;
                                    userBloc.controller.jumpToTab(1);
                                  },
                              ),
                              const TextSpan(
                                text:
                                    " page to discover and connect with new people.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  shrinkWrap: true,
                  viewType: ViewType.list,
                  initialLoader: const ExploreViewShimmerLoader(),
                  query: FirebaseFirestore.instance
                      .collection('chats')
                      .where(Filter.or(
                          Filter('user1UserId',
                              isEqualTo: AuthService().getUser()!.uid),
                          Filter('user2UserId',
                              isEqualTo: AuthService().getUser()!.uid)))
                      .orderBy('compatibility', descending: true),
                  itemBuilder: (context, snapshot, index) {
                    context
                        .read<ChatsBloc>()
                        .add(CacheChats(snapshsot: snapshot));
                    final Chat chat =
                        Chat.fromDocumentSnapshot(snapshot.elementAt(index));
                    return ChatsViewTile(
                      chat: chat,
                      onClick: () {
                        final messageBloc = context.read<MessagesBloc>();
                        final userBloc = context.read<UserBloc>();
                        context.read<MessagesBloc>().add(InitChat(
                            ownerUser: userBloc.state.user!, chat: chat));

                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: BlocProvider.value(
                              value: userBloc,
                              child: BlocProvider.value(
                                value: messageBloc,
                                child: const MessagingView(),
                              )),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                    );
                  },
                );
              } else {
                if (state.searchingState == SearchingState.loading) {
                  return const ExploreViewShimmerLoader();
                } else {
                  return state.searchedChat.isEmpty
                      ? const Center(child: Text('No Chats found!'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.searchedChat.length,
                          itemBuilder: (context, index) {
                            return ChatsViewTile(
                              chat: state.searchedChat[index],
                              onClick: () {
                                final messageBloc =
                                    context.read<MessagesBloc>();
                                final userBloc = context.read<UserBloc>();
                                context.read<MessagesBloc>().add(InitChat(
                                    ownerUser: userBloc.state.user!,
                                    chat: state.searchedChat[index]));

                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: BlocProvider.value(
                                      value: userBloc,
                                      child: BlocProvider.value(
                                        value: messageBloc,
                                        child: const MessagingView(),
                                      )),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                            );
                          },
                        );
                }
              }
            },
          ))
        ],
      )),
    );
  }
}
