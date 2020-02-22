import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class Clock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  static const int TASK_MINUTES = 25;
  static const int BREAK_MINUTES = 5;
  String _time = '';
  LeftTime _leftTime;
  bool _isPause = true;
  String _buttonLabel = "START";
  int _interval = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _leftTime = LeftTime(0);
    Timer.periodic(
      Duration(seconds: 1),
      _onTimer,
    );
    super.initState();

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future notify() async {
    var isBreak = _interval % 2 == 0;
    var title = isBreak ? 'short break' : 'doing task';
    var message = isBreak ? '少し休憩しましょう。' : 'タスクに取り掛かりましょう。';
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, message, platformChannelSpecifics);
  }

  void _onTimer(Timer timer) {
    if (_isPause) return;
    setState(() => _time = _leftTime.getLeftMinutes());
    _leftTime.countDown();
    if (_leftTime.left < 0) {
      _interval++;
      notify();
      var min = _interval % 2 == 0 ? BREAK_MINUTES : TASK_MINUTES;
      _leftTime = LeftTime(min);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        _time,
        style: TextStyle(
          fontSize: 60.0,
          fontFamily: 'IBMPlexMono',
        ),
      ),
      RaisedButton(
          child: Text(_buttonLabel),
          onPressed: () {
            _isPause = !_isPause;
            setState(() => _buttonLabel = _isPause ? "START" : "PAUSE");
          })
    ]);
  }
}

class LeftTime {
  int _left;

  LeftTime(int minutes) {
    _left = minutes * 60;
  }

  int get _leftMinutes => (_left / 60).floor();

  int get _leftSeconds => _left % 60;

  int get left => _left;

  String getLeftMinutes() {
    var minutes = _leftMinutes.toString().padLeft(2, "0");
    var seconds = _leftSeconds.toString().padLeft(2, "0");
    return "${minutes}:${seconds}";
  }

  void countDown({int sec = 1}) {
    _left -= sec;
  }
}
