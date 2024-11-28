import 'package:feel_sync/CustomUI.dart';
import 'package:feel_sync/bloc/user/user_bloc.dart';
import 'package:feel_sync/bloc/user/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
            child: Center(
              child: Stack(alignment: Alignment.bottomRight, children: [
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Stack(children: [
                      CustomAvatar(
                          radius: 19, url: state.user!.profileLocation),
                      if (state.profileState == ProfileState.loading)
                        Positioned.fill(
                            child: ClipOval(
                          child: Container(
                              color: Colors.black.withOpacity(0.5),
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
          )
        ],
      )),
    );
  }
}
