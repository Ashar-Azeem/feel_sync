import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class CompatibilityShimmerContainer extends StatelessWidget {
  const CompatibilityShimmerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 6.w, right: 6.w, top: 4.w, bottom: 4.w),
                child: Column(
                  children: [
                    const Text(
                      "Age Group",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(211, 255, 255, 255)),
                    ),
                    const SizedBox(height: 16),
                    _buildBarChart({
                      "16-22": 55,
                      "23-29": 83,
                      "30-36": 96,
                      "37-43": 99,
                      "44-50": 60,
                      "50+": 30,
                    }, "Age Group"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 6.w, right: 6.w, top: 4.w, bottom: 4.w),
                child: Column(
                  children: [
                    const Text(
                      "Gender",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(211, 255, 255, 255)),
                    ),
                    const SizedBox(height: 16),
                    _buildBarChart({
                      "Male": 72,
                      "Female": 85,
                    }, "Gender"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> data, String xAxisLabel) {
    return SizedBox(
      height: 37.h, // Constrain the height of the bar chart
      child: Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 52, 66, 89),
        highlightColor: const Color.fromARGB(255, 191, 236, 252),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            barGroups: data.entries.map((entry) {
              return BarChartGroupData(
                x: data.keys.toList().indexOf(entry.key),
                barRods: [
                  BarChartRodData(
                    toY: entry.value
                        .toDouble(), // Use the original value directly
                    color: Colors.blue,
                    width: 16,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ],
              );
            }).toList(),
            maxY: 100, // Fix the maximum Y value to 100
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 10, // Fixed interval of 10
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: EdgeInsets.only(top: 2.w),
                      child: Text(
                        "${value.toInt()}%",
                        style: TextStyle(
                            color: const Color.fromARGB(
                              211,
                              255,
                              255,
                              255,
                            ),
                            fontSize: 2.w),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize:
                      50, // Increase reserved size for better visibility
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= data.keys.length) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 12.0), // Add extra padding
                      child: Text(
                        data.keys.elementAt(
                          index,
                        ),
                        style: TextStyle(
                            color: const Color.fromARGB(211, 255, 255, 255),
                            fontSize: 2.5.w),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(
                show: true, horizontalInterval: 10), // Fixed grid interval
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                    color: Colors.grey.shade300, width: 1), // Add border
              ),
            ),
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final key = data.keys.elementAt(group.x.toInt());
                  return BarTooltipItem(
                    "$key\n",
                    const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: "${rod.toY.toStringAsFixed(1)}%",
                        style: const TextStyle(color: Colors.yellow),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
