import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:uhl_link/utils/constants.dart';
import 'academic_calendar_ViewHeader.dart';
import 'academic_calendar_Header.dart';
import 'package:build_daemon/constants.dart';

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
        centerTitle: true,
        title: Text('Academic Calendar', style: TextStyle(
          fontSize: 20,
        ),),
      ),
      body: Column(
        children: [

          buildHeader(_goToPreviousMonth,_headerText,_goToNextMonth),
          viewHeader(),
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
