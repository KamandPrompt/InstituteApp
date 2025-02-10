import 'package:flutter/material.dart';

class viewHeader extends StatelessWidget {
  const viewHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Background color of the view header
      padding: EdgeInsets.symmetric(vertical: 5), // Vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Evenly space the day labels
        children: List.generate(7, (index) {
          // List of abbreviated day names
          final dayName = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index];
          // Check if the day is a weekend (Sunday or Saturday)
          final isWeekend = index == 0 || index == 6;
          return Text(
            dayName,
            style: TextStyle(
              color: isWeekend ? Color(0xFFFFA24D) : Color(0xFF3283D5), // Red color for weekends
              fontWeight: FontWeight.bold,
              fontSize: 12// Bold text
            ),
          );
        }),
      ),
    );
  }
}