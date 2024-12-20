import 'package:feel_sync/Utilities/ReusableUI/AnalysisView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Analysisview extends StatelessWidget {
  const Analysisview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                  "Analytics",
                  style: GoogleFonts.getFont('League Spartan',
                      textStyle: TextStyle(
                          fontSize: 8.w,
                          color: const Color.fromARGB(255, 8, 152, 204),
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: CompatibilityBarCharts(
              ageGroupCompatibility: {
                "18-24": 75.0,
                "25-34": 85.0,
                "35-44": 65.0,
                "45-54": 50.0,
                "55+": 40.0,
              },
              genderCompatibility: {
                "Male": 80.0,
                "Female": 90.0,
              },
            ),
          )
        ],
      )),
    );
  }
}
