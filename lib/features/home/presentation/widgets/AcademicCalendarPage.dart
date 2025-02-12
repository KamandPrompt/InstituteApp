import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:uhl_link/utils/constants.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarController _calendarController;
  String _headerText = '';
  TimeOfDay? _selectedTime;


  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _headerText = DateFormat('MMMM yyyy').format(DateTime.now());
  }

  void _onViewChanged(ViewChangedDetails details) {
    final DateTime midDate = details.visibleDates[details.visibleDates.length ~/ 2];
    final String newHeaderText = DateFormat('MMMM yyyy').format(midDate);
    if (_headerText != newHeaderText) {
      setState(() {
        _headerText = newHeaderText;
      });
    }
  }

  void _goToPreviousMonth() {
    _calendarController.backward!();
  }

  void _goToNextMonth() {
    _calendarController.forward!();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Academic Calender",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [

            buildHeader(_goToPreviousMonth,_headerText,_goToNextMonth),
            buildViewHeader(),
            //

            Expanded(
              child: SfCalendar(
                controller: _calendarController,
                todayHighlightColor: Color(0xFF3283D5),
                view: CalendarView.month,
                headerHeight: 0,
                viewHeaderHeight: 0,
                backgroundColor: Colors.white,
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  showTrailingAndLeadingDates: false,
                ),
                dataSource: MeetingDataSource(Constants.getAllDayEvents()),
                onViewChanged: _onViewChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<Appointment> _getDataSource() {
    List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(Duration(hours: 2));
    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: "subject",
      color: Color(0xFF3283D5),
    ));
    return meetings;
  }
}



class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}




  Container buildViewHeader() {
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

