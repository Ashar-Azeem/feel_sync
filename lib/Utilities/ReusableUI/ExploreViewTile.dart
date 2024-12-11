import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Utilities/constants.dart';
import 'package:feel_sync/Views/VisitingUserView.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

class ExploreViewTile extends StatelessWidget {
  final User user;
  final VoidCallback onMessagePressed;
  const ExploreViewTile(
      {super.key, required this.user, required this.onMessagePressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: VisitingUserView(hostUser: user),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.slideUp,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, right: 2.w),
        child: SizedBox(
          height: 10.h,
          width: 100.w,
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: user.profileLocation == null
                    ? const AssetImage('assets/blankprofile.png')
                    : NetworkImage(user.profileLocation!),
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
                            user.userName,
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ),
                    SizedBox(
                        width: 57.w,
                        child: Text(
                          user.bio.isEmpty ? defaultBio : user.bio,
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
                    onPressed: onMessagePressed,
                    icon: const Icon(
                      Icons.message_outlined,
                      color: Colors.white,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
