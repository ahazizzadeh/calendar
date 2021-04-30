import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'CalnederEvents.dart';

class CalendarWiget extends StatefulWidget {
  CalendarWiget(this.selectedDay, this.events);
  final DateTime selectedDay;
  final List<Map> events;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarWiget> {
  CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
    _controller.view = CalendarView.day;
  }

  Widget dayHeader(DateTime date, {bool isToday = true}) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: isToday
            ? LinearGradient(begin: Alignment.topLeft, colors: [
                Color.fromRGBO(109, 7, 203, 1),
                Color.fromRGBO(239, 173, 255, 1)
              ])
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            date.day.toString(),
            style: TextStyle(color: isToday ? Colors.white : Colors.black54),
          ),
          Text(
            DateFormat('MMM').format(date),
            style: TextStyle(color: isToday ? Colors.white : Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget weekHeader() {
    int numWeek = widget.selectedDay.weekday;
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            dayHeader(
                widget.selectedDay.add(
                  Duration(
                    days: -(numWeek - 1),
                  ),
                ),
                isToday: numWeek == 1),
            dayHeader(
                widget.selectedDay.add(
                  Duration(
                    days: -(numWeek - 2),
                  ),
                ),
                isToday: numWeek == 2),
            dayHeader(
                widget.selectedDay.add(
                  Duration(
                    days: -(numWeek - 3),
                  ),
                ),
                isToday: numWeek == 3),
            dayHeader(
                widget.selectedDay.add(
                  Duration(
                    days: -(numWeek - 4),
                  ),
                ),
                isToday: numWeek == 4),
            dayHeader(
                widget.selectedDay.add(
                  Duration(
                    days: -(numWeek - 5),
                  ),
                ),
                isToday: numWeek == 5),
            dayHeader(
                widget.selectedDay.add(
                  Duration(
                    days: -(numWeek - 6),
                  ),
                ),
                isToday: numWeek == 6),
            dayHeader(
                widget.selectedDay.add(
                  Duration(
                    days: -(numWeek - 7),
                  ),
                ),
                isToday: numWeek == 7),
          ],
        ),
      ),
    );
  }

  Widget calenderWidget() {
    return SfCalendar(
      key: ValueKey([_controller.selectedDate, _controller.view]),
      view: _controller.view ?? CalendarView.day,
      firstDayOfWeek: 1,
      headerHeight: 0,
      viewHeaderHeight: 0,
      timeZone: 'Asia/Tehran',
      timeSlotViewSettings: TimeSlotViewSettings(
          timeIntervalHeight: 58, timeFormat: 'Hm', timeRulerSize: 111),
      initialDisplayDate: widget.selectedDay,
      dataSource: MeetingDataSource(_getDataSource(widget.events)),
      appointmentBuilder: (BuildContext context,
              CalendarAppointmentDetails calendarAppointmentDetails) =>
          appointmentWidge(context, calendarAppointmentDetails),
    );
  }

  Widget appointmentWidge(
      context, CalendarAppointmentDetails calendarAppointmentDetails) {
    final Meeting appointment = calendarAppointmentDetails.appointments.first;
    return _controller.view == CalendarView.day
        ? Container(
            width: calendarAppointmentDetails.bounds.width,
            height: calendarAppointmentDetails.bounds.height,
            color: appointment.backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: appointment.secondColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: setIcon(appointment.typeEvent),
                ),
                Expanded(
                  child: ListTile(
                    title: Row(children: [
                      Text(
                        appointment.eventName,
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 10),
                      Text(
                        appointment.typeEvent,
                        style: TextStyle(
                            fontSize: 12,
                            color: appointment.secondColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                    subtitle: Text(
                      appointment.typeEvent == "Homework"
                          ? ' Deadline : ' +
                              DateFormat('jm').format(appointment.to)
                          : DateFormat('jm').format(appointment.from) +
                              ' - ' +
                              DateFormat('jm').format(appointment.to),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                appointment.typeEvent == "Webinar Course" ||
                        appointment.typeEvent == "One-to-One Class"
                    ? Column(children: [
                        Expanded(child: Container()),
                        TextButton(
                            child: Container(
                              height: 30,
                              alignment: Alignment.bottomCenter,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: appointment.secondColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                appointment.typeEvent == "Webinar Course"
                                    ? "Join Webinar"
                                    : "Join Class",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {})
                      ])
                    : Container(),
              ],
            ),
          )
        : Container(
            width: calendarAppointmentDetails.bounds.width,
            height: calendarAppointmentDetails.bounds.height,
            color: appointment.backgroundColor,
            child: SizedBox.expand(
              child: ListTile(
                title: Text(
                  appointment.eventName,
                  style: TextStyle(fontSize: 12),
                ),
                subtitle: Text(
                  appointment.typeEvent == "Homework"
                      ? ' Deadline : ' + DateFormat('jm').format(appointment.to)
                      : DateFormat('jm').format(appointment.from) +
                          ' - ' +
                          DateFormat('jm').format(appointment.to),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          );
  }

  List<Meeting> _getDataSource(List allDaysData) {
    final List<Meeting> meetings = <Meeting>[];
    for (Map everyDay in allDaysData) {
      for (Map event in everyDay["events"]) {
        final DateTime startTime = DateTime.parse(event["startTime"]);
        final DateTime endTime = DateTime.parse(event["endTime"]);
        meetings.add(Meeting(
            event["title"],
            event["type"],
            startTime,
            endTime,
            setColor(event["colorCode"], background: true),
            setColor(event["colorCode"], background: false),
            event["isAllDay"]));
      }
    }
    return meetings;
  }

  Color? setColor(int colorCode, {background = true}) {
    switch (colorCode) {
      case 1:
        return background ? Colors.blue[200] : Colors.blue;
      case 2:
        return background ? Colors.green[200] : Colors.green;
      case 3:
        return background ? Colors.purple[200] : Colors.purple;
      case 4:
        return background ? Colors.blueGrey[200] : Colors.blueGrey;
      case 5:
        return background ? Colors.yellow[200] : Colors.yellow;
      case 6:
        return background ? Colors.red[200] : Colors.red;
      default:
        return background ? Colors.grey[200] : Colors.grey;
    }
  }

  Icon setIcon(String type) {
    switch (type) {
      case "Webinar Course":
        return Icon(Icons.monitor, color: Colors.white);
      case "Video Course":
        return Icon(Icons.videocam_rounded, color: Colors.white);
      case "One-to-One Class":
        return Icon(Icons.people, color: Colors.white);
      case "Homework":
        return Icon(Icons.mode_edit, color: Colors.white);
      case "Quiz":
        return Icon(Icons.sticky_note_2_outlined, color: Colors.white);
      default:
        return Icon(Icons.all_out_sharp, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _controller.selectedDate = widget.selectedDay;
    });
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
          child: Row(
            children: [
              Text(
                DateFormat('MMMM dd , yyyy').format(widget.selectedDay),
              ),
              Expanded(
                child: Container(),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _controller.view == CalendarView.day
                      ? _controller.view = CalendarView.week
                      : _controller.view = CalendarView.day;
                }),
                child: Container(
                  width: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _controller.view == CalendarView.day ? 'Day' : 'Week',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(
          thickness: 0.5,
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, right: 5),
                child: Text(
                  "GMT + 3:30",
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ),
              TextButton(
                  style: TextButton.styleFrom(minimumSize: Size(16, 16)),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                  onPressed: () {}),
              VerticalDivider(
                thickness: 0.5,
                color: Colors.grey[350],
              ),
              _controller.view == CalendarView.day
                  ? dayHeader(widget.selectedDay)
                  : weekHeader(),
            ],
          ),
        ),
        Expanded(
          child: calenderWidget(),
        )
      ]),
    );
  }
}
