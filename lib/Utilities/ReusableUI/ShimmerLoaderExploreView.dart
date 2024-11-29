import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';

class ExploreViewShimmerLoader extends StatelessWidget {
  const ExploreViewShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 52, 66, 89),
      highlightColor: const Color.fromARGB(255, 191, 236, 252),
      child: ListView.builder(
        itemCount: 12,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: SizedBox(
              height: 10.h,
              width: 100.w,
              child: Row(
                children: [
                  CircleAvatar(
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
                              child: Divider(
                                thickness: 3.w,
                              )),
                        ),
                        SizedBox(
                            width: 65.w,
                            child: Divider(
                              thickness: 3.w,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
