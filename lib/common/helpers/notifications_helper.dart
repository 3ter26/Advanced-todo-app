import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/common/models/task_model.dart';
import 'package:todo_app/features/todo/pages/view_not.dart';

class NotificationsHelper {
  NotificationsHelper({
    required this.ref,
  });
  final WidgetRef ref;
//---
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedNotificationPayload;

  final BehaviorSubject<String?> selectedNotificationSubject =
      BehaviorSubject<String?>();
//---
  intializeNotification() async {
    _configureSelectNotificationSubject(); //this method setup a listener on selected notif. Subject stream, to handle incoming notif's by displaying a dialog box.
    await _configureLocalTimeZone(); //by this, we re going to set the local time zone for our notif.
    final DarwinInitializationSettings
        darwinInitializationSettingsIOS = //this step is used for IOS, we need to intialize the drawin settings
        DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final AndroidInitializationSettings
        androidInitializationSettings = //here, for the Android intializationSettings + icon
        const AndroidInitializationSettings("calender ");
    final InitializationSettings
        initializationSettings = //here we're creating an intializationsettings object for both OS's.
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings, //here, we're calling the intialize method on the flutterlocalnotifPlugin
        onDidReceiveBackgroundNotificationResponse: (data) async {
      if (data != null) {
        //here we're just making sure that the data isn't null
        debugPrint('notification payload: ${data.payload!}');
      }
      selectedNotificationSubject.add(data.payload);
    });
  }

  void requestIOSPermissions() {
    //request permission for the user, dor showing them notifications in their mobile phones
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          //when the user allow, these values are converted tot rue
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones(); //to inititlzie the timezone db
    const String timeZoneName = 'Asia/Shanghai';
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    showDialog(
      context: ref.context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(body ?? ""),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  scheduledNotification(
      int days, int hours, int minutes, int seconds, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id ?? 0,
      task.title,
      task.desc,
      tz.TZDateTime.now(tz.local).add(Duration(
          days: days, hours: hours, minutes: minutes, seconds: seconds)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
      )),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload:
          "${task.title} | ${task.desc} | ${task.date} | ${task.startTime} | ${task.endTime}",
    );
  }

  void _configureSelectNotificationSubject() {
    selectedNotificationSubject.stream.listen((String? payload) async {
      var title =
          payload!.split('|')[0]; //deconstucting the data of thatpayload
      var body = payload.split('|')[1];
      showDialog(
        context: ref.context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(
            body,
            textAlign: TextAlign.justify,
            maxLines: 4,
          ),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationsPage(payload: payload)));
              },
              child: const Text('View'),
            ),
          ],
        ),
      );
    });
  }
}
