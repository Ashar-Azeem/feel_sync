import 'package:feel_sync/Services/AuthService.dart';
import 'package:feel_sync/Utilities/ReusableUI/AnalysisView.dart';
import 'package:feel_sync/Utilities/ReusableUI/ShimmerAnalysisView.dart';
import 'package:feel_sync/bloc/AnalysisBloc/analysis_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class Analysisview extends StatelessWidget {
  const Analysisview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AnalysisBloc()..add(FetchData(userId: AuthService().getUser()!.uid)),
      child: Scaffold(
        body: SafeArea(
            child: BlocBuilder<AnalysisBloc, AnalysisState>(
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<AnalysisBloc>()
                    .add(FetchData(userId: AuthService().getUser()!.uid));
              },
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
                  SliverToBoxAdapter(
                      child: BlocBuilder<AnalysisBloc, AnalysisState>(
                    builder: (context, state) {
                      return state.loading
                          ? const CompatibilityShimmerContainer()
                          : CompatibilityBarCharts(
                              ageGroupCompatibility: state.ageGroupAnalysis,
                              genderCompatibility: state.genderGroupAnalysis);
                    },
                  ))
                ],
              ),
            );
          },
        )),
      ),
    );
  }
}
