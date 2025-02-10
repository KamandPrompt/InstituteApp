import 'package:flutter/material.dart';

Container buildHeader(_goToPreviousMonth(),String _headerText,_goToNextMonth()) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_left, color: Color(0xFF3283D5), size: 30),
          onPressed: _goToPreviousMonth,
        ),
        Text(
          _headerText,
          style: TextStyle(
            color: Color(0xFF3283D5),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_right, color: Color(0xFF3283D5), size: 30),
          onPressed: _goToNextMonth,
        ),
      ],
    ),
  );
}
