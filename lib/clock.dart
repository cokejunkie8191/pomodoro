import 'package:flutter/material.dart';
import 'dart:async';

class Clock extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ClockState();
  }
}

class _ClockState extends State<Clock> {
  String _time = '25:00';
  LeftTime _leftTime;
  bool _isPause = true;
  String _buttonLabel = "START";
  int _interval = 0;

  @override
  void initState() {
    _leftTime = LeftTime(25);
    Timer.periodic(
      Duration(seconds: 1),
      _onTimer,
    );
    super.initState();
  }

  void _onTimer(Timer timer) {
    if (_isPause) return;
    setState(() => _time = _leftTime.getLeftMinutes());
    _leftTime.countDown();
    if (_leftTime.left < 0) {
      print("ZERO!!");
      _interval++;
      var min = _interval % 2 == 0 ? 25 : 5;
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
