import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_sync/Utilities/ReusableUI/ExploreViewTile.dart';
import 'package:feel_sync/Utilities/ReusableUI/ShimmerLoaderExploreView.dart';
import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/bloc/ExploreUsers/explore_users_bloc.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({super.key});

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  late TextEditingController search;
  late Timer timer;
  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (search.text.isEmpty) {
        context.read<ExploreUsersBloc>().add(SearchEnded());
      } else {
        context.read<ExploreUsersBloc>().add(Search(query: search.text));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            backgroundColor: const Color.fromARGB(255, 12, 15, 20),
            pinned: true,
            forceMaterialTransparency: false,
            title: Padding(
              padding: EdgeInsets.only(left: 2.w, top: 3.w),
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
                  "Explore",
                  style: GoogleFonts.getFont('League Spartan',
                      textStyle: TextStyle(
                          fontSize: 8.w,
                          color: const Color.fromARGB(255, 8, 152, 204),
                          fontWeight: FontWeight.w500)),
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
                  cursorColor: Colors.white,
                  enableSuggestions: false,
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
              child: BlocBuilder<ExploreUsersBloc, ExploreUsersState>(
            buildWhen: (previous, current) {
              if (previous.searchedUser != current.searchedUser ||
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
                  shrinkWrap: true,
                  viewType: ViewType.list,
                  initialLoader: const ExploreViewShimmerLoader(),
                  query: FirebaseFirestore.instance
                      .collection('users')
                      .where(FieldPath.documentId,
                          isNotEqualTo: AuthService().getUser()!.uid)
                      .orderBy("userName"),
                  itemBuilder: (context, snapshot, index) {
                    context
                        .read<ExploreUsersBloc>()
                        .add(FetchUsers(snapshsot: snapshot));
                    final User user =
                        User.fromDocumentSnapshot(snapshot.elementAt(index));
                    return ExploreViewTile(user: user);
                  },
                );
              } else {
                if (state.searchingState == SearchingState.loading) {
                  return const ExploreViewShimmerLoader();
                } else {
                  return state.searchedUser.isEmpty
                      ? const Center(child: Text('No User Found!'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.searchedUser.length,
                          itemBuilder: (context, index) {
                            return ExploreViewTile(
                              user: state.searchedUser[index],
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
