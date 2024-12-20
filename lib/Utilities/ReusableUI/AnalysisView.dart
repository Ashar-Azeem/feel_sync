import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class CompatibilityBarCharts extends StatelessWidget {
  final Map<String, double>
      ageGroupCompatibility; // Age groups and compatibility percentages
  final Map<String, double>
      genderCompatibility; // Gender and compatibility percentages

  const CompatibilityBarCharts({
    super.key,
    required this.ageGroupCompatibility,
    required this.genderCompatibility,
  });

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
                    _buildBarChart(ageGroupCompatibility, "Age Group"),
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
                    _buildBarChart(genderCompatibility, "Gender"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, double> data, String xAxisLabel) {
    return SizedBox(
      height: 35.h, // Constrain the height of the bar chart
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: data.entries.map((entry) {
            return BarChartGroupData(
              x: data.keys.toList().indexOf(entry.key),
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  color: Colors.blue,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  return Text("${value.toInt()}%");
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
                      data.keys.elementAt(index),
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
          gridData: const FlGridData(show: true, horizontalInterval: 10),
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
                      fontWeight: FontWeight.bold, color: Colors.white),
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
    );
  }
}
