import 'package:feel_sync/Utilities/ReusableUI/CustomAvatar.dart';
import 'package:feel_sync/Utilities/constants.dart';
import 'package:feel_sync/Views/login.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:sizer/sizer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.logOutState == LogOutState.yes) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
            builder: (BuildContext context) {
              return const LoginView();
            },
          ), (_) => false);
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
                pinned: true,
                forceMaterialTransparency: true,
                backgroundColor: Colors.transparent,
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
                      "Profile",
                      style: GoogleFonts.getFont('League Spartan',
                          textStyle: TextStyle(
                              fontSize: 8.w,
                              color: const Color.fromARGB(255, 8, 152, 204),
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.w, left: 2.w),
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          color: const Color.fromARGB(255, 34, 42, 55),
                          onSelected: (String result) {
                            if (result == 'logout') {
                              context
                                  .read<UserBloc>()
                                  .add(LogOut(context: context));
                            }
                          },
                          itemBuilder: (context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                value: "logout",
                                child: state.logOutState == LogOutState.loading
                                    ? const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        strokeCap: StrokeCap.round,
                                      )
                                    : const ListTile(
                                        leading: Icon(
                                          Icons.logout_outlined,
                                          color: Colors.white,
                                        ),
                                        title: Text(
                                          'Logout',
                                          style: TextStyle(color: Colors.white),
                                        )),
                              ),
                            ];
                          },
                        );
                      },
                    ),
                  ),
                ]),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Center(
                  child: Stack(alignment: Alignment.bottomRight, children: [
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return Stack(children: [
                          CustomAvatar(
                              radius: 18.8, url: state.user!.profileLocation),
                          if (state.profileState == ProfileState.loading)
                            Positioned.fill(
                                child: ClipOval(
                              child: Container(
                                  color: const Color.fromARGB(255, 34, 42, 55),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  )),
                            ))
                        ]);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<UserBloc>().add(ChangeProfilePicture());
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 8, 152, 204),
                        radius: 6.w,
                        child: const ClipOval(
                            child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        )),
                      ),
                    )
                  ]),
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
                      BlocBuilder<UserBloc, UserState>(
                        buildWhen: (previous, current) {
                          if (previous.user!.userName !=
                                  current.user!.userName ||
                              previous.user!.name != current.user!.name) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            "Name",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 171, 170, 170)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50.w,
                                          child: Text(
                                            state.user!.name,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<UserBloc>()
                                          .add(ChangeName(context: context));
                                    },
                                    child: Center(
                                      child: BlocBuilder<UserBloc, UserState>(
                                        builder: (context, state) {
                                          return state.nameState ==
                                                  NameStates.loading
                                              ? const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  strokeCap: StrokeCap.round,
                                                )
                                              : Icon(
                                                  Icons.edit_outlined,
                                                  color: const Color.fromARGB(
                                                      255, 8, 152, 204),
                                                  size: 6.w,
                                                );
                                        },
                                      ),
                                    ),
                                  )
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 0.75.w),
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
                                              state.user!.userName,
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        context.read<UserBloc>().add(
                                            ChangeUserName(context: context));
                                      },
                                      child: Center(
                                        child: BlocBuilder<UserBloc, UserState>(
                                          builder: (context, state) {
                                            return state.userNameState ==
                                                    UserNameStates.loading
                                                ? const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    strokeCap: StrokeCap.round,
                                                  )
                                                : Icon(
                                                    Icons.edit_outlined,
                                                    color: const Color.fromARGB(
                                                        255, 8, 152, 204),
                                                    size: 6.w,
                                                  );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
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
                                      InkWell(
                                        onTap: () {
                                          context.read<UserBloc>().add(
                                              ChangeAboutSection(
                                                  context: context));
                                        },
                                        child: Center(
                                          child:
                                              BlocBuilder<UserBloc, UserState>(
                                            builder: (context, state) {
                                              return state.aboutSectionState ==
                                                      AboutSectionStates.loading
                                                  ? const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      strokeCap:
                                                          StrokeCap.round,
                                                    )
                                                  : Icon(
                                                      Icons.edit_outlined,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 8, 152, 204),
                                                      size: 6.w,
                                                    );
                                            },
                                          ),
                                        ),
                                      )
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
    );
  }
}
