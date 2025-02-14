import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:uhl_link/utils/constants.dart';

class AcademicCalendarPage extends StatefulWidget {
  const AcademicCalendarPage({super.key});

  @override
  State<AcademicCalendarPage> createState() => _AcademicCalendarPageState();
}

class _AcademicCalendarPageState extends State<AcademicCalendarPage> {
  late CalendarController _calendarController;
  String _headerText = '';

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _headerText = DateFormat('MMMM yyyy').format(DateTime.now());
  }

  void _onViewChanged(ViewChangedDetails details) {
    final DateTime midDate =
        details.visibleDates[details.visibleDates.length ~/ 2];
    final String newHeaderText = DateFormat('MMMM yyyy').format(midDate);
    if (_headerText != newHeaderText) {
      setState(() {
        _headerText = newHeaderText;
      });
    }
  }


  Container buildViewHeader() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Background color of the view header
      padding: const EdgeInsets.symmetric(vertical: 5), // Vertical padding
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Evenly space the day labels
        children: List.generate(7, (index) {
          // List of abbreviated day names
          final dayName =
              ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index];
          // Check if the day is a weekend (Sunday or Saturday)
          final isWeekend = index == 0 || index == 6;
          return Text(
            dayName,
            style: TextStyle(
                color: isWeekend? const Color(0xFFFFA24D)
                        : Theme.of(context).primaryColor
                    , // Red color for weekends
                fontWeight: FontWeight.bold,
                fontSize: 12 // Bold text
                ),
          );
        }),
      ),
    );
  }



  Container buildHeader( String headerText) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left,
                color: Theme.of(context).primaryColor, size: 30),
            onPressed:() {
              _calendarController.forward!();
            },
          ),
          Text(
            headerText,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: Theme.of(context).primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon:  Icon(Icons.arrow_right,
                color: Theme.of(context).primaryColor, size: 30),
            onPressed: () {
              _calendarController.backward!();
            },
          ),
        ],
      ),
    );
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

        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Column(
          children: [
            buildHeader( _headerText),
            buildViewHeader(),
            Expanded(
              child: SfCalendar(
                controller: _calendarController,
                todayHighlightColor: Theme.of(context).primaryColor,
                view: CalendarView.month,
                headerHeight: 0,
                viewHeaderHeight: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                monthViewSettings: const MonthViewSettings(
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
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
