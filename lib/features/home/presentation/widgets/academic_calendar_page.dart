import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:vertex/utils/constants.dart';

class AcademicCalendarPage extends StatefulWidget {
  const AcademicCalendarPage({super.key});

  @override
  State<AcademicCalendarPage> createState() => _AcademicCalendarPageState();
}

class _AcademicCalendarPageState extends State<AcademicCalendarPage> {
  final CalendarController _calendarController = CalendarController();
  String _headerText = '';

  @override
  void initState() {
    _headerText = DateFormat('MMMM yyyy').format(DateTime.now());
    super.initState();
  }

  Container buildHeader(String headerText) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left,
                color: Theme.of(context).primaryColor, size: 33),
            onPressed: () {
              _calendarController.backward!();
            },
          ),
          Text(
            headerText,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right,
                color: Theme.of(context).primaryColor, size: 33),
            onPressed: () {
              _calendarController.forward!();
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildHeader(_headerText),
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                    maxWidth: MediaQuery.of(context).size.width),
                child: SfCalendar(
                  controller: _calendarController,
                  todayHighlightColor: Theme.of(context).primaryColor,
                  view: CalendarView.month,
                  headerHeight: 0,
                  viewHeaderHeight: 40,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  monthViewSettings: MonthViewSettings(
                      showAgenda: true,
                      agendaViewHeight: 150,
                      agendaItemHeight: 50,
                      agendaStyle: AgendaStyle(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        dayTextStyle: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(
                                fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      dayFormat: "EEE",
                      monthCellStyle: MonthCellStyle(
                        textStyle: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(
                                fontSize: 13, fontWeight: FontWeight.w600),
                      )),
                  dataSource: CalenderData(Constants.getAllDayEvents()),
                  onViewChanged: (ViewChangedDetails details) {
                    final DateTime midDate =
                        details.visibleDates[details.visibleDates.length ~/ 2];
                    final String newHeaderText =
                        DateFormat('MMMM yyyy').format(midDate);
                    if (_headerText != newHeaderText) {
                      setState(() {
                        _headerText = newHeaderText;
                      });
                    }
                  },
                  viewHeaderStyle: ViewHeaderStyle(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    dayTextStyle: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalenderData extends CalendarDataSource {
  CalenderData(List<Appointment> source) {
    appointments = source;
  }
}
