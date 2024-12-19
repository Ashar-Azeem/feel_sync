import 'package:feel_sync/Models/Chat.dart';
import 'package:feel_sync/Utilities/ReusableUI/CustomAvatar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmotionAnalysis extends StatefulWidget {
  final Chat chat;
  final int receiverNumber;
  const EmotionAnalysis(
      {super.key, required this.chat, required this.receiverNumber});

  @override
  State<EmotionAnalysis> createState() => _EmotionAnalysisState();
}

class _EmotionAnalysisState extends State<EmotionAnalysis> {
  late Map<String, int> senderEmotions;
  late Map<String, int> receiverEmotions;

  @override
  void initState() {
    super.initState();
    if (widget.receiverNumber == 1) {
      senderEmotions = widget.chat.user2Emotions;
      receiverEmotions = widget.chat.user1Emotions;
    } else {
      senderEmotions = widget.chat.user1Emotions;
      receiverEmotions = widget.chat.user2Emotions;
    }
  }

  Color _getColorForEmotion(String emotion) {
    switch (emotion) {
      case 'Anger':
        return Colors.red;
      case 'Fear':
        return Colors.blueGrey;
      case 'Joy':
        return Colors.yellow;
      case 'Love':
        return Colors.pink;
      case 'Sadness':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<PieChartSectionData> getList(Map<String, int> emotions) {
    final total = emotions.values.reduce((sum, value) => sum + value);
    return emotions.entries.map((entry) {
      final percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        titleStyle: const TextStyle(color: Colors.black),
        value: entry.value.toDouble(),
        title:
            '${percentage.toStringAsFixed(1)}%', // Show percentage on the chart
        color: _getColorForEmotion(entry.key),
        radius: 70,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        title: const Text("Emotion Analysis"),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Card(
                child: SizedBox(
                  width: 90.w,
                  height: 44.h,
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      children: [
                        CustomAvatar(
                          radius: 2.w,
                          url: widget.receiverNumber == 1
                              ? widget.chat.user2ProfileLoc
                              : widget.chat.user1ProfileLoc,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: SizedBox(
                            height: 16.h,
                            width: 80.w,
                            child: PieChart(
                              PieChartData(
                                sections: getList(senderEmotions),
                                centerSpaceRadius:
                                    35, // Space in the middle of the chart
                                sectionsSpace: 2, // Space between pie sections
                              ),
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.linear,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                widget.chat.user2Emotions.entries.map((entry) {
                              final color = _getColorForEmotion(entry.key);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: color,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.w,
                                      ),
                                      Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Card(
                child: SizedBox(
                  width: 90.w,
                  height: 44.h,
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      children: [
                        CustomAvatar(
                          radius: 2.w,
                          url: widget.receiverNumber == 1
                              ? widget.chat.user1ProfileLoc
                              : widget.chat.user2ProfileLoc,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: SizedBox(
                            height: 16.h,
                            width: 80.w,
                            child: PieChart(
                              PieChartData(
                                sections: getList(receiverEmotions),
                                centerSpaceRadius:
                                    35, // Space in the middle of the chart
                                sectionsSpace: 2, // Space between pie sections
                              ),
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.linear,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                widget.chat.user2Emotions.entries.map((entry) {
                              final color = _getColorForEmotion(entry.key);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: color,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.w,
                                      ),
                                      Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
