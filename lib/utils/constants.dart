import 'dart:ui';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class Constants {
  // Light Theme
  static Color primaryLight = const Color(0xFF3283D5);
  static Color scaffoldBackgroundColorLight = const Color(0xFFFFFFFF);
  static Color textColorActiveLight = const Color(0xFF212121);
  static Color textColorInactiveLight = const Color(0xFF606260);
  static Color cardLight = const Color(0xFFF4F4F4);
  static Color errorLight = const Color(0xFFE55D59);

  // Dark Theme
  static Color primaryDark = const Color(0xFF3283D5);
  static Color scaffoldBackgroundColorDark = const Color(0xFF1A1A1A);
  static Color textColorActiveDark = const Color(0xFFFFFFFF);
  static Color textColorInactiveDark = const Color(0xFF9A9A9A);
  static Color cardDark = const Color(0xFF212121);
  static Color errorDark = const Color(0xFFE55D59);

  static Map<String, Map<String, List<String>>> mess_menu = {
    "Monday": {
      "Breakfast": [
        "Aloo onion paratha",
        "Chutney",
        "Curd",
        "Fruits / Eggs",
        "Daliya",
        "Milk(200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong+Lemon)"
      ],
      "Lunch": [
        "Arher Dal",
        "Veg Kofta",
        "",
        "Roti",
        "Rice",
        "",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Snacks": [
        "Macroni / Pasta",
        "Coffee"
      ],
      "Dinner": [
        "Aloo Palak",
        "Dal Fry",
        "Motichur Laddu",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Tuesday": {
      "Breakfast": [
        "Puri",
        "Chana Masala",
        "Halwa",
        "",
        "Cornflakes",
        "Milk(200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Moong Dal",
        "Cabbage-Matar",
        "Rice",
        "Roti",
        "",
        "Bundi Raita",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Snacks": [
        "Pav Bhaji",
        "Tea"
      ],
      "Dinner": [
        "Mix Veg (gajar+paneer or Mushroom+bean +gobi+matar)",
        "Dal Tadka",
        "Besan Burfi",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Wednesday": {
      "Breakfast": [
        "Mix Paratha",
        "Dhaniya Chutney",
        "Curd",
        "",
        "Daliya",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Kadhi Pakora",
        "Kaddu Khatta",
        "Masala Papad / Fryums",
        "Roti",
        "Jeera Rice",
        "",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Snacks": [
        "Veg Sandwich",
        "Tea"
      ],
      "Dinner": [
        "Kadahi Paneer / ChickenCurry",
        "Red Massor Dal",
        "Fruit Custard",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Thursday": {
      "Breakfast": [
        "Poha",
        "Green Chutney",
        "",
        "Fruits / 2 Omlette",
        "Daliya",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "White Chole",
        "Aloo Began Bhartha",
        "Poori",
        "Bundi Raita",
        "Rice",
        "",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Snacks": [
        "Fried Idli",
        "Tea"
      ],
      "Dinner": [
        "Aloo Gobhi",
        "Dal Makhni",
        "Besan Halwa",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Friday": {
      "Breakfast": [
        "Idli",
        "Sambhar & chutney",
        "",
        "2 Banana / 2 Eggs",
        "Cornflakes",
        "Milk(200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Rajma",
        "Aloo Tamatar Sabzi",
        "Jeera Rice",
        "Roti",
        "",
        "Curd",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Snacks": [
        "Chana peanut Chat",
        "Tea"
      ],
      "Dinner": [
        "Paneer butter masala / Egg Curry",
        "Mix Dal",
        "Gulab Jamun",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Saturday": {
      "Breakfast": [
        "Methi / Palak paratha",
        "Aloo Tamatar Sabji",
        "",
        "Fruits / 2 Eggs",
        "Cornflakes",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Paneer Bhurji, Egg Bhurji",
        "Chana Dal",
        "",
        "Roti",
        "Rice",
        "",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Snacks": [
        "Samosa+Imli Chat",
        "Tea"
      ],
      "Dinner": [
        "Sarso ka Saag",
        "Dal Fry",
        "Kheer",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Sunday": {
      "Breakfast": [
        "Masala Onion Dosa",
        "Sambar",
        "Coconut Chutney",
        "",
        "Daliya",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Bhature",
        "Chole",
        "Green Chutney",
        "Fried Masala Chilli",
        "Khichdi",
        "Butter Milk",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Snacks": [
        "Bhel Poori or Bread Pakoda",
        "Coffee"
      ],
      "Dinner": [
        "Paneer Biryani / Chicken Biryani",
        "Aloo soyabean",
        "Raita",
        "Ice Cream",
        "Roti",
        "",
        "Green Salad",
        "Lemon + Pickle"
      ]
    }
  };
  static List<Appointment> getAllDayEvents()  {
    return[
  // January 2025
  Appointment(
  subject: "Classes Begin",
  startTime: DateTime(2025, 1, 17),
  endTime: DateTime(2025, 1, 17),
  isAllDay: true,
  color: Colors.deepPurple,
  ),
  Appointment(
  subject: "Republic Day",
  startTime: DateTime(2025, 1, 26),
  endTime: DateTime(2025, 1, 26),
  isAllDay: true,
  color: Colors.red,
  ),
  Appointment(
  subject: "Last date to Add/Drop courses",
  startTime: DateTime(2025, 1, 27),
  endTime: DateTime(2025, 1, 27),
  isAllDay: true,
  color: Colors.blueGrey,
  ),
  Appointment(
    subject: "Midsem TCF (upto 2nd March)",
    startTime: DateTime(2025, 2, 24),
    endTime: DateTime(2025, 2, 24),
    isAllDay: true,
    color: Colors.blueGrey,
  ),
  Appointment(
    subject: "Maha Shivaratri",
    startTime: DateTime(2025, 2, 26),
    endTime: DateTime(2025, 2, 26),
    isAllDay: true,
    color: Colors.orangeAccent,
  ),

  // March 2025
  Appointment(
  subject: "Mid-Sem Exams",
  startTime: DateTime(2025, 3, 3),
  endTime: DateTime(2025, 3, 6),
  isAllDay: true,
  color: Colors.deepPurple,
  ),
  Appointment(
    subject: "Holi",
    startTime: DateTime(2025, 3, 14),
    endTime: DateTime(2025, 3, 14),
    isAllDay: true,
    color: Colors.orangeAccent,
  ),
  Appointment(
  subject: "Mid-Sem Break",
  startTime: DateTime(2025, 3, 8),
  endTime: DateTime(2025, 3, 16),
  isAllDay: true,
  color: Colors.lightBlue,
  ),
  Appointment(
    subject: "Last Day for Showing/Seeing Answer Sheets",
    startTime: DateTime(2025, 3, 20),
    endTime: DateTime(2025, 3, 20),
    isAllDay: true,
    color: Colors.lightBlue,
  ),
  Appointment(
    subject: "Id-ul-Fitr",
    startTime: DateTime(2025, 3, 31),
    endTime: DateTime(2025, 3, 31),
    isAllDay: true,
    color: Colors.purple,
  ),

  Appointment(
    subject: "XPECTO",
    startTime: DateTime(2025, 3, 29),
    endTime: DateTime(2025, 3, 31),
    isAllDay: true,
    color: Colors.blueAccent.shade400,
  ),

      // April 2025
  Appointment(
  subject: "Mahavir Jayanti",
  startTime: DateTime(2025, 4, 10),
  endTime: DateTime(2025, 4, 10),
  isAllDay: true,
  color: Colors.orange,
  ),
  Appointment(
  subject: "Good Friday",
  startTime: DateTime(2025, 4, 18),
  endTime: DateTime(2025, 4, 18),
  isAllDay: true,
  color: Colors.brown,
  ),

  // May 2025
  Appointment(
  subject: "Final TCF Submission upto 15 May",
  startTime: DateTime(2025, 5, 5),
  endTime: DateTime(2025, 5, 5),
  isAllDay: true,
  color: Colors.purple,
  ),
  Appointment(
    subject: "Budh Purnima",
    startTime: DateTime(2025, 5, 5),
    endTime: DateTime(2025, 5, 5),
    isAllDay: true,
    color: Colors.orangeAccent,
  ),
  Appointment(
  subject: "Last Day of Teaching",
  startTime: DateTime(2025, 5, 14),
  endTime: DateTime(2025, 5, 14),
  isAllDay: true,
  color: Colors.teal,
  ),
  Appointment(
  subject: "End-Sem Exams",
  startTime: DateTime(2025, 5, 16),
  endTime: DateTime(2025, 5, 23),
  isAllDay: true,
  color: Colors.redAccent,
  ),
  Appointment(
  subject: "Annual Vacation",
  startTime: DateTime(2025, 5, 25),
  endTime: DateTime(2025, 7, 31),
  isAllDay: true,
  color: Colors.green,
  ),
  Appointment(
    subject: "Last Day for Showing Answer Sheets",
    startTime: DateTime(2025, 5, 27),
    endTime: DateTime(2025, 5, 27),
    isAllDay: true,
    color: Colors.lightBlue,
  ),
  Appointment(
    subject: "Grade Submission",
    startTime: DateTime(2025, 5, 29),
    endTime: DateTime(2025, 5, 29),
    isAllDay: true,
    color: Colors.purple,
  ),
  // June 2025
  Appointment(
  subject: "Summer Term Classes Begin",
  startTime: DateTime(2025, 6, 2),
  endTime: DateTime(2025, 6, 2),
  isAllDay: true,
  color: Colors.blueGrey,
  ),
  Appointment(
    subject: "Bakr-Id",
    startTime: DateTime(2025, 6, 7),
    endTime: DateTime(2025, 6, 7),
    isAllDay: true,
    color: Colors.brown ,
  ),

  // July 2025
  Appointment(
    subject: "Muharram",
    startTime: DateTime(2025, 7, 6),
    endTime: DateTime(2025, 7, 6),
    isAllDay: true,
    color: Colors.brown ,
  ),
  Appointment(
    subject: "Last Day of Teaching Summer Term",
    startTime: DateTime(2025, 7, 18),
    endTime: DateTime(2025, 7, 18),
    isAllDay: true,
    color: Colors.lightBlue ,
  ),
  Appointment(
  subject: "Supplementary/Summer Exams",
  startTime: DateTime(2025, 7, 21),
  endTime: DateTime(2025, 7, 25),
  isAllDay: true,
  color: Colors.orangeAccent,
  ),
  Appointment(
  subject: "Grade Submission for Summer Exams",
  startTime: DateTime(2025, 7, 31),
  endTime: DateTime(2025, 7, 31),
  isAllDay: true,
  color: Colors.pinkAccent,
  ),

  // August 2025
  Appointment(
    startTime: DateTime(2025, 8, 1, 9, 0),
    endTime: DateTime(2025, 8, 1, 10, 0),
    subject: 'Classes Begin-Students report to FA',
    isAllDay: true,
  ),
  Appointment(
    startTime: DateTime(2025, 8, 11, 9, 0),
    endTime: DateTime(2025, 8, 11, 10, 0),
    subject: 'Last Date to Add/Drop Courses',
    color: Colors.teal,
    isAllDay: true,
  ),
  Appointment(
    startTime: DateTime(2025, 8, 16),
    endTime: DateTime(2025, 8, 16, 23, 59),
    subject: 'Janmashtami',
    color: Colors.deepOrange,
    isAllDay: true,
  ),
  Appointment(
  subject: "Independence Day",
  startTime: DateTime(2025, 8, 15),
  endTime: DateTime(2025, 8, 15),
  isAllDay: true,
  color: Colors.green,
  ),

  // September 2025
  Appointment(
  subject: "Mid-Sem TCF (upto 21st)",
  startTime: DateTime(2025, 9, 15),
  endTime: DateTime(2025, 9, 15),
  isAllDay: true,
  color: Colors.blueAccent,
  ),
  Appointment(
    subject: "Mid-Sem Exams",
    startTime: DateTime(2025, 9, 22),
    endTime: DateTime(2025, 9, 25),
    isAllDay: true,
    color: Colors.deepPurpleAccent,
  ),

  // October 2025
  Appointment(
  subject: "Gandhi Jayanti",
  startTime: DateTime(2025, 10, 2),
  endTime: DateTime(2025, 10, 2),
  isAllDay: true,
  color: Colors.lightGreen,
  ),
  Appointment(
    subject: "Dussera",
    startTime: DateTime(2025, 10, 2),
    endTime: DateTime(2025, 10, 2),
    isAllDay: true,
    color: Colors.deepOrange
  ),
  Appointment(
  subject: "Mid-Sem Break",
  startTime: DateTime(2025, 10, 18),
  endTime: DateTime(2025, 10, 26),
  isAllDay: true,
  color: Colors.deepPurple,
  ),
  Appointment(
  subject: "Diwali",
  startTime: DateTime(2025, 10, 20),
  endTime: DateTime(2025, 10, 20),
  isAllDay: true,
  color: Colors.orange,
  ),

  // November 2025
  Appointment(
  subject: "Gurunanak Jayanti",
  startTime: DateTime(2025, 11, 5),
  endTime: DateTime(2025, 11, 5),
  isAllDay: true,
  color: Colors.yellow,
  ),
  Appointment(
  subject: "Final TCF Submission till 28th",
  startTime: DateTime(2025, 11, 17),
  endTime: DateTime(2025, 11, 17),
  isAllDay: true,
  color: Colors.brown,
  ),
  Appointment(
  subject: "Last Day of Teaching",
  startTime: DateTime(2025, 11, 26),
  endTime: DateTime(2025, 11, 26),
  isAllDay: true,
  color: Colors.teal,
  ),

  // December 2025
  Appointment(
  subject: "Winter Vacations",
  startTime: DateTime(2025, 12, 8),
  endTime: DateTime(2025, 12, 31),
  isAllDay: true,
  color: Colors.green,
  ),
  Appointment(
  subject: "Christmas",
  startTime: DateTime(2025, 12, 25),
  endTime: DateTime(2025, 12, 25),
  isAllDay: true,
  color: Colors.blue,
  ),
  ];
  }



}


