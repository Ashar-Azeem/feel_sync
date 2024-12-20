import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class CompatibilityShimmerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
              child: Column(children: [
                const Text(
                  "Age Group",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(211, 255, 255, 255)),
                ),
                const SizedBox(height: 16),
                _buildShimmerPlaceholder(5),
              ]),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: EdgeInsets.only(top: 5.w, bottom: 5.w),
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
                  _buildShimmerPlaceholder(2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerPlaceholder(int numberOfBars) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 52, 66, 89),
      highlightColor: const Color.fromARGB(255, 191, 236, 252),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  numberOfBars,
                  (index) => Container(
                    width: 20,
                    height: (50 + index * 60)
                        .toDouble(), // Varying heights for shimmer effect
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                  numberOfBars, // Number of x-axis labels
                  (index) => Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey),
                      )),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                numberOfBars, // Number of x-axis labels
                (index) => Container(
                  width: 30,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4),
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
