import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Utilities/ReusableUI/CustomAvatar.dart';
import 'package:feel_sync/Utilities/constants.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class VisitingUserView extends StatelessWidget {
  final User hostUser;
  const VisitingUserView({super.key, required this.hostUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                          color: const Color.fromARGB(255, 8, 152, 204),
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 4.h, bottom: 4),
              child: Center(
                child:
                    CustomAvatar(radius: 18.8, url: hostUser.profileLocation),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              width: 80.w,
              height: 10.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Used to animate the circular progress indicator to a specific range :(start: 0,end: 0.6)
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 60 / 100),
                    duration: const Duration(milliseconds: 1800),
                    builder: (context, value, child) =>
                        CircularProgressIndicator(
                      value: value,
                      backgroundColor: Colors.white,
                      color: const Color.fromARGB(255, 44, 98, 185),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: SizedBox(
                height: 14.h,
                child: Row(
                  children: [
                    SizedBox(
                      width: 16.w,
                      child: Center(
                          child: Icon(
                        Icons.person_outline_outlined,
                        size: 9.w,
                        weight: 5,
                        color: const Color.fromARGB(255, 171, 170, 170),
                      )),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 74.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 0.75.w),
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
                          width: 80.w,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 74.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 0.75.w),
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
                                        overflow: TextOverflow.ellipsis,
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
              padding: EdgeInsets.only(bottom: 5.h, top: 5.h),
              child: SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: 16.w,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          Icons.info_outline,
                          size: 7.5.w,
                          weight: 5,
                          color: const Color.fromARGB(255, 171, 170, 170),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 74.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 0.75.w),
                                            child: const Text(
                                              "About",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 171, 170, 170)),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 71.w,
                                              child: ReadMoreText(
                                                state.user!.bio.isEmpty
                                                    ? defaultBio
                                                    : state.user!.bio,
                                                trimMode: TrimMode.Length,
                                                trimLength: 300,
                                                colorClickableText:
                                                    const Color.fromARGB(
                                                        255, 123, 211, 243),
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
    );
  }
}
