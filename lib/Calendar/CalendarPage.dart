import 'package:flutter/material.dart';

import 'datas.dart';
import 'SideBar.dart';
import 'CalendarWidget.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime selectedDay;



  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
  }

  changeSelectedDay(newDay) {
    setState(() {
      selectedDay = newDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: Color.fromRGBO(246, 248, 250, 1),
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: CalendarWiget(selectedDay, events),
          ),
        ),
        Container(
            width: 350,
            color: Color.fromRGBO(239, 240, 247, 0.45),
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: SideBar(changeSelectedDay, selectedDay, events))
      ],
    );
  }
}
