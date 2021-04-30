import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SideBar extends StatefulWidget {
  SideBar(this.changeSelectedDate, this.selectedDay, this.events);
  final Function changeSelectedDate;
  final DateTime selectedDay;
  final List<Map> events;

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
  }

  Widget datePicker(DateTime selectedDate) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: 150,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color.fromRGBO(239, 240, 246, 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Text(DateFormat('MMM').format(selectedDate),
              style: TextStyle(fontSize: 13)),
          SizedBox(
            width: 10,
          ),
          Text(selectedDate.year.toString(), style: TextStyle(fontSize: 13)),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  style: TextButton.styleFrom(minimumSize: Size(12, 12)),
                  child: Icon(
                    Icons.keyboard_arrow_up_outlined,
                    color: Colors.black,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _focusedDay =
                          DateTime(selectedDate.year, selectedDate.month - 1);
                    });
                  }),
              TextButton(
                  style: TextButton.styleFrom(minimumSize: Size(12, 12)),
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _focusedDay =
                          DateTime(selectedDate.year, selectedDate.month + 1);
                    });
                  })
            ],
          )
        ],
      ),
    );
  }

  void newEvent(selectedDay, focusedDay) {
    widget.changeSelectedDate(selectedDay);
  }

  Widget monthlyView() {
    DateTime today = DateTime.now();
    return TableCalendar(
      availableGestures: AvailableGestures.none,
      daysOfWeekHeight: 40,
      rowHeight: 35,
      firstDay: today.add(const Duration(days: -180)),
      lastDay: today.add(const Duration(days: 180)),
      focusedDay: _focusedDay ?? widget.selectedDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: false,
      selectedDayPredicate: (day) {
        return isSameDay(widget.selectedDay, day);
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        markerSize: 35,
        markersAnchor: 0.95,
        markersAlignment: Alignment.center,
        cellMargin: EdgeInsets.all(2),
        markerDecoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(244, 183, 64, 1)),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        selectedTextStyle: TextStyle(color: Color.fromRGBO(109, 7, 203, 1)),
        selectedDecoration: BoxDecoration(
            border:
                Border.all(color: Color.fromRGBO(109, 7, 203, 1), width: 1.5),
            shape: BoxShape.circle),
        todayDecoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, colors: [
            Color.fromRGBO(109, 7, 203, 1),
            Color.fromRGBO(239, 173, 255, 1)
          ]),
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Color.fromRGBO(244, 183, 64, 1)),
        weekendStyle: TextStyle(color: Color.fromRGBO(244, 183, 64, 1)),
      ),
      onDaySelected: (selectedDay, focusedDay) =>
          newEvent(selectedDay, focusedDay),
      eventLoader: (day) {
        return _getEventsForDay(day);
      },
    );
  }

  List _getEventsForDay(DateTime day) {
    List dailyEvents = [];
    widget.events.forEach((element) {
      if (element["timeDate"] == day.toString()) {
        dailyEvents.add(element["events"]);
      }
    });
    return dailyEvents;
  }

  Widget upComingPlans() {
    return ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (BuildContext context, int index) {
        return dayCards(widget.events[index]);
      },
    );
  }

  Widget dayCards(Map dailyEvents) {
    var dayCard = <Widget>[];
    dayCard.add(
      Container(
        padding: EdgeInsets.only(top: 30, bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          DateFormat('dd MMM').format(
            DateTime.parse(dailyEvents["timeDate"]),
          ),
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
    dayCard.addAll([
      Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: dailyEvents["events"]
              .map<Widget>((var event) => eventWidet(event))
              .toList())
    ]);
    return Column(children: dayCard);
  }

  Widget eventWidet(event) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color.fromRGBO(247, 247, 252, 1),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            child: Text(
              DateFormat("jm").format(
                DateTime.parse(event["startTime"]),
              ),
            ),
          ),
          Container(
            color: setColor(event["colorCode"]),
            width: 5,
            height: 40,
          ),
          Expanded(
            child: ListTile(
              title: Text(
                event["title"],
                style: TextStyle(fontSize: 12),
              ),
              subtitle: Text(
                event["type"],
                style: TextStyle(fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Color setColor(colorCode) {
    switch (colorCode) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.blueGrey;
      case 5:
        return Colors.yellow;
      case 6:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text('Calendar'),
          ),
          Divider(
            thickness: 0.5,
          ),
          datePicker(_focusedDay ?? widget.selectedDay),
          Container(
            child: monthlyView(),
          ),
          Divider(
            thickness: 0.5,
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 2),
            alignment: Alignment.centerLeft,
            child: Text(
              'Upcoming Plans',
            ),
          ),
          Expanded(child: upComingPlans())
        ],
      ),
    );
  }
}
