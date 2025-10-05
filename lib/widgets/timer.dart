import 'dart:async';

// Removed improper imports from internal Flutter src packages
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class TimerController extends ValueNotifier<bool> {
  TimerController({bool isPlaying = false}) : super(isPlaying);

  void startTimer() => value = true;
  void stopTimer() => value = false;
}

class timerClock extends StatefulWidget {
  final TimerController controller;
  const timerClock({super.key, required this.controller});

  @override
  State<timerClock> createState() => _timerClockState();
}

class _timerClockState extends State<timerClock> {
   bool isRunning = false;
  Duration duration = Duration();
  Timer? timer;
  void reset() => setState(() {
        duration = Duration();
      });
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.value) {
        startTimer();
      } else {
        stopTimer();
      }
    });
  }

  void addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void startTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
      setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      addTime();
    });
  }

  void stopTimer({bool resets = true}) {
    if (!mounted) return;
    if (resets) {
      reset();
    }
    setState(() {
       isRunning = false;
      timer?.cancel();
    });
  }

  Widget build(BuildContext context) {
    return buildTime();
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: Colors.black,
      width: 2.0,
    ),
  ),
  child: Container(
  width: 300,
  height: 300,
  decoration: BoxDecoration(
    color:Color.fromARGB(255, 15, 53, 143),
    shape: BoxShape.circle,
    border: Border.all(width: 10, color:isRunning? Colors.red:  Color.fromARGB(255, 255, 255, 255)),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Icon(Icons.mic, size: 60,color:isRunning? Colors.red: Colors.white,),
      Text(
        '$minutes:$seconds',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 60,color: Colors.white),
      ),
      Text( isRunning?
        'Recording...':'Click On Me To Start\n           Recording',
        style: TextStyle(fontSize: 16,color: isRunning? Colors.red: Colors.white),
      ),
    ],
  ),
),
    );

  }
}
