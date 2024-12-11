import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Utilities/ReusableUI/ChatsViewTile.dart';
import 'package:feel_sync/Utilities/ReusableUI/ShimmerLoaderExploreView.dart';
import 'package:feel_sync/bloc/ChatsBloc/chats_bloc.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
                  EdgeInsets.only(left: 4.w, right: 4.w, top: 1.h, bottom: 2.h),
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
                      // context.read<ExploreUsersBloc>().add(SearchEnded());
                    } else {
                      // context
                      // .read<ExploreUsersBloc>()
                      // .add(Search(query: search.text));
                    }
                  },
                  cursorColor: Colors.white,
                  enableSuggestions: true,
                  autocorrect: false,
                  controller: search,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      contentPadding: EdgeInsets.only(top: 1.5.h),
                      prefixIcon: const Icon(Icons.search)),
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
                  onEmpty: const Center(
                    child: Text('No Chats Available'),
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
                      .orderBy('compatibility'),
                  itemBuilder: (context, snapshot, index) {
                    context
                        .read<ChatsBloc>()
                        .add(CacheChats(snapshsot: snapshot));
                    final Chat chat =
                        Chat.fromDocumentSnapshot(snapshot.elementAt(index));
                    return ChatsViewTile(chat: chat);
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
