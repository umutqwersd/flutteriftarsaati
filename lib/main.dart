import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IftarApp(),
    );
  }
}

class IftarApp extends StatefulWidget {
  @override
  _IftarAppState createState() => _IftarAppState();
}

class _IftarAppState extends State<IftarApp> {
  TimeOfDay iftarTime = TimeOfDay(hour: 19, minute: 0);
  String remainingTime = '';
  TimeOfDay currentTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    updateRemainingTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => updateRemainingTime());
  }

  void updateRemainingTime() {
    DateTime now = DateTime.now();
    DateTime iftarDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      iftarTime.hour,
      iftarTime.minute,
    );

    int differenceInSeconds = iftarDateTime.difference(now).inSeconds;

    if (differenceInSeconds < 0) {
      iftarDateTime = iftarDateTime.add(Duration(days: 1));
      differenceInSeconds = iftarDateTime.difference(now).inSeconds;
    }

    int hours = (differenceInSeconds / 3600).floor();
    int minutes = ((differenceInSeconds % 3600) / 60).floor();
    int seconds = differenceInSeconds % 60;

    setState(() {
      remainingTime = '$hours saat $minutes dakika $seconds saniye kaldı';
    });
  }

  void setIftarTime(TimeOfDay newTime) {
    setState(() {
      iftarTime = newTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İftara Kalan Süre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'İftar Saati: ${iftarTime.hour}:${iftarTime.minute}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              remainingTime,
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              child: Text('İftar Saatini Değiştir'),
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: iftarTime,
                ).then((newTime) {
                  if (newTime != null) {
                    setIftarTime(newTime);
                    updateRemainingTime();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
