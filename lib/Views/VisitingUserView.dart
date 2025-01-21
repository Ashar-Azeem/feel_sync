import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Utilities/ReusableUI/CustomAvatar.dart';
import 'package:feel_sync/Utilities/constants.dart';
import 'package:feel_sync/bloc/ChatsBloc/chats_bloc.dart';
import 'package:feel_sync/bloc/VisitingUserCompatibility/visiting_user_compatibility_bloc.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class VisitingUserView extends StatelessWidget {
  final User hostUser;
  const VisitingUserView({super.key, required this.hostUser});

  double calculateSize(int age) {
    double maxSize = 6.h;
    double minSize = 4.h;
    if (age >= 30) return maxSize;
    const int minAge = 16;
    const int maxAge = 30;
    double normalizedAge =
        (age.clamp(minAge, maxAge) - minAge) / (maxAge - minAge);
    return (normalizedAge * (maxSize - minSize)) + minSize;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VisitingUserCompatibilityBloc()
        ..add(MeasureCompatibility(userId: hostUser.userId)),
      child: BlocBuilder<ChatsBloc, ChatsState>(
        buildWhen: (previous, current) =>
            previous.findingChatStatus != current.findingChatStatus,
        builder: (context, state) {
          return Stack(children: [
            Scaffold(
              body: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      forceMaterialTransparency: true,
                      backgroundColor: Colors.transparent,
                      title: Padding(
                        padding: EdgeInsets.only(top: 3.w),
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
                            "Profile",
                            style: GoogleFonts.getFont('League Spartan',
                                textStyle: TextStyle(
                                    fontSize: 8.w,
                                    color:
                                        const Color.fromARGB(255, 8, 152, 204),
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: IconButton(
                              onPressed: () {
                                final userBlocState =
                                    context.read<UserBloc>().state;
                                //This Fetches the chat from the server or the cache
                                context.read<ChatsBloc>().add(FetchChat(
                                    ownerUser: userBlocState.user!,
                                    otherUser: hostUser));
                              },
                              icon: const Icon(
                                Icons.message,
                                color: Colors.blue,
                              )),
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Center(
                          child: CustomAvatar(
                              radius: 18.8, url: hostUser.profileLocation),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: SizedBox(
                          height: 14.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18.w,
                                child: Center(
                                    child: Icon(
                                  Icons.person_outline_outlined,
                                  size: 9.w,
                                  weight: 5,
                                  color:
                                      const Color.fromARGB(255, 171, 170, 170),
                                )),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 74.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 0.75.w),
                                              child: const Text(
                                                "Name",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 171, 170, 170)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 50.w,
                                              child: Text(
                                                hostUser.name,
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 1.5.w,
                                  ),
                                  SizedBox(
                                    width: 75.w,
                                    child: const Divider(
                                      thickness: 2,
                                      color: Color.fromARGB(255, 29, 36, 48),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 1.5.w,
                                  ),
                                  SizedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 74.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 0.75.w),
                                                child: const Text(
                                                  "User Name",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 171, 170, 170)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 45.w,
                                                child: Text(
                                                  hostUser.userName,
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: SizedBox(
                          width: 75.w,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18.w,
                                child: Icon(Icons.bar_chart_outlined,
                                    size: 9.w,
                                    weight: 5,
                                    color: const Color.fromARGB(
                                        255, 171, 170, 170)),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                surfaceTintColor:
                                    const Color.fromARGB(255, 8, 11, 25),
                                child: SizedBox(
                                  height: 15.h,
                                  width: 34.w,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text(
                                        "Compatibility",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      BlocBuilder<VisitingUserCompatibilityBloc,
                                          VisitingUserCompatibilityState>(
                                        builder: (context, state) {
                                          return state.compatibilityMeasure !=
                                                  null
                                              ? TweenAnimationBuilder<double>(
                                                  tween: Tween<double>(
                                                      begin: 0,
                                                      end: state
                                                              .compatibilityMeasure! /
                                                          100),
                                                  duration: const Duration(
                                                      milliseconds: 1800),
                                                  builder:
                                                      (context, value, child) =>
                                                          ClipOval(
                                                    child: SizedBox(
                                                      height: 6.h,
                                                      width: 6.h,
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: value,
                                                        backgroundColor:
                                                            Colors.white,
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Shimmer.fromColors(
                                                  baseColor:
                                                      const Color.fromARGB(
                                                          255, 52, 66, 89),
                                                  highlightColor:
                                                      const Color.fromARGB(
                                                          255, 191, 236, 252),
                                                  child: ClipOval(
                                                    child: SizedBox(
                                                      height: 6.h,
                                                      width: 6.h,
                                                      child:
                                                          const CircularProgressIndicator(
                                                        strokeCap:
                                                            StrokeCap.round,
                                                        color: Color.fromARGB(
                                                            255, 52, 66, 89),
                                                        value: 100,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                        },
                                      ),
                                      BlocBuilder<VisitingUserCompatibilityBloc,
                                          VisitingUserCompatibilityState>(
                                        builder: (context, state) {
                                          return Text(state
                                                      .compatibilityMeasure ==
                                                  null
                                              ? "0"
                                              : "${state.compatibilityMeasure}%");
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                surfaceTintColor:
                                    const Color.fromARGB(255, 8, 11, 25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: SizedBox(
                                  height: 15.h,
                                  width: 34.w,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text(
                                          "Traits",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                          child: TweenAnimationBuilder<double>(
                                              curve: Easing.legacy,
                                              tween: Tween<double>(
                                                  begin: 4.h,
                                                  end: calculateSize(
                                                      hostUser.age)),
                                              duration: const Duration(
                                                  milliseconds: 1500),
                                              builder: (context, value,
                                                      child) =>
                                                  Icon(
                                                    hostUser.gender == "Male"
                                                        ? Icons.man
                                                        : Icons.woman_rounded,
                                                    size: value,
                                                  )),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 1.w),
                                          child: RichText(
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                const TextSpan(
                                                    text: 'Age: ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255,
                                                            171,
                                                            170,
                                                            170))),
                                                TextSpan(
                                                    text: hostUser.age
                                                        .toString()),
                                              ],
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Gender: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color.fromARGB(
                                                          255, 171, 170, 170))),
                                              TextSpan(text: hostUser.gender),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5.h, top: 2.h),
                        child: SizedBox(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18.w,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 9.w,
                                    weight: 5,
                                    color: const Color.fromARGB(
                                        255, 171, 170, 170),
                                  ),
                                ),
                              ),
                              BlocBuilder<UserBloc, UserState>(
                                buildWhen: (previous, current) {
                                  if (previous.user!.bio != current.user!.bio) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                builder: (context, state) {
                                  return Row(
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 74.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: 0.75.w),
                                                      child: const Text(
                                                        "About",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    171,
                                                                    170,
                                                                    170)),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: 71.w,
                                                        child: ReadMoreText(
                                                          hostUser.bio.isEmpty
                                                              ? defaultBio
                                                              : state.user!.bio,
                                                          trimMode:
                                                              TrimMode.Length,
                                                          trimLength: 300,
                                                          colorClickableText:
                                                              const Color
                                                                  .fromARGB(
                                                                  255,
                                                                  123,
                                                                  211,
                                                                  243),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (state.findingChatStatus == FindingChatStatus.loading)
              Positioned.fill(
                  child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Container(
                    height: 17.w,
                    width: 38.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.0),
                      color: const Color.fromARGB(255, 37, 37, 39),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: const CupertinoActivityIndicator(
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Loading...',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ))
          ]);
        },
      ),
    );
  }
}
