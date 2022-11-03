import 'dart:async';

import 'package:flutter/material.dart';

class TaskOrgniserScreen extends StatefulWidget {
  const TaskOrgniserScreen({super.key});

  @override
  State<TaskOrgniserScreen> createState() => _TaskOrgniserScreenState();
}

class _TaskOrgniserScreenState extends State<TaskOrgniserScreen> {
  int noOfTask = 1;

  incrementNoOfTask() {
    setState(() {
      noOfTask++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView.builder(
              itemCount: noOfTask,
              itemBuilder: ((context, index) {
                return TaskWidget(incrementNoOfTask, noOfTask);
              }))),
    );
  }
}

class TaskWidget extends StatefulWidget {
  final Function incrementTask;
  final taskNumber;
  TaskWidget(this.incrementTask, this.taskNumber);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  int duration = 0;

  Timer? timer;

  String convertDurationToHourMinuteAndSeconds(String str) {
    int duration = int.parse(str);
    int hours = (duration / 3600).floor();
    String formattedHours = hours.toString();
    if (hours <= 9) formattedHours = "0$formattedHours";
    int remainingDuration = duration.remainder(3600);
    int minutes = (remainingDuration / 60).floor();
    String formattedMinutes = minutes.toString();
    if (minutes <= 9) formattedMinutes = "0$formattedMinutes";
    int seconds = remainingDuration.remainder(60);
    String formattedSeconds = seconds.toString();
    if (seconds <= 9) formattedSeconds = "0$formattedSeconds";
    return "$formattedMinutes (m) : $formattedSeconds (s)";
  }

  final _task = TextEditingController();

  bool taskEnabled = true;

  bool showTimer = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                if (_task.text.isNotEmpty) {
                  FocusScope.of(context).unfocus();

                  setState(() {
                    taskEnabled = false;
                  });
                  widget.incrementTask();
                }
              },
              icon: const Icon(
                Icons.add,
                color: Colors.green,
              )),
          Expanded(
            child: InkWell(
              onTap: () {
                if (!taskEnabled && _task.text.isNotEmpty && timer == null) {
                  FocusScope.of(context).unfocus();
                  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    setState(() {
                      duration++;
                    });
                  });
                  setState(() {
                    showTimer = true;
                  });
                } else
                  timer?.cancel();
              },
              child: TextFormField(
                controller: _task,
                enabled: taskEnabled,
                onFieldSubmitted: (_) {
                  if (_task.text.isNotEmpty) {
                    FocusScope.of(context).unfocus();

                    setState(() {
                      taskEnabled = false;
                    });
                    widget.incrementTask();
                  }
                },
                autofocus: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(14),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    hintText: "Enter Task ${widget.taskNumber.toString()}"),
                cursorColor: Colors.black,
              ),
            ),
          ),
          if (showTimer)
            Text(
              convertDurationToHourMinuteAndSeconds(duration.toString()),
              style: const TextStyle(color: Colors.blue),
            )
        ],
      ),
    );
  }
}
