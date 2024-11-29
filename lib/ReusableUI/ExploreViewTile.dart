import 'package:feel_sync/Models/user.dart';
import 'package:feel_sync/Utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExploreViewTile extends StatelessWidget {
  final User user;
  const ExploreViewTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, right: 4.w),
      child: SizedBox(
        height: 10.h,
        width: 100.w,
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: user.profileLocation == null
                  ? const AssetImage('assets/blankprofile')
                  : NetworkImage(user.profileLocation!),
              backgroundColor: const Color.fromARGB(255, 34, 42, 55),
              radius: 9.w,
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 2.w),
                    child: SizedBox(
                        width: 40.w,
                        child: Text(
                          user.userName,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ),
                  SizedBox(
                      width: 65.w,
                      child: Text(
                        user.bio.isEmpty ? defaultBio : user.bio,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
