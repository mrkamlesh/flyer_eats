import 'dart:io';

import 'package:clients/bloc/foodorder/bloc.dart';
import 'package:clients/classes/push_notification_manager.dart';
import 'package:clients/page/notifications_list_page.dart';
import 'package:clients/page/track_order_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clients/bloc/currentorder/current_order_bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/page/login/login_number_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'bloc/location/home/home_bloc.dart';
import 'bloc/notification/bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<HomeBloc>(
        create: (context) {
          return HomeBloc();
        },
      ),
      BlocProvider<FoodOrderBloc>(
        create: (context) {
          return FoodOrderBloc();
        },
      ),
      BlocProvider<NotificationBloc>(
        create: (context) {
          return NotificationBloc();
        },
      ),
      BlocProvider<LoginBloc>(
        create: (context) {
          return LoginBloc();
        },
      ),
      BlocProvider<CurrentOrderBloc>(
        create: (context) {
          return CurrentOrderBloc();
        },
      )
    ], child: MainPage());
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PushNotificationsManager manager = PushNotificationsManager();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _requestIOSPermissions();
    manager.firebaseMessaging
        .requestNotificationPermissions(IosNotificationSettings());
    manager.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (message['data']['push_type'] == 'order') {
          _showOrderNotification(message);
        } else if (message['data']['push_type'] == "campaign") {
          _showCampaignNotification(message);
        }
      },
      //onBackgroundMessage: onBackgroundMessage,
      onResume: (Map<String, dynamic> message) async {
        if (message['data']['push_type'] == "order") {
          _navigateToActiveOrderPage();
        } else if (message['data']['push_type'] == "campaign") {
          _navigateToCampaign(message['data']['order_id']);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        BlocProvider.of<NotificationBloc>(context).add(UpdateMessage(message));
      },
    );

    BlocProvider.of<LoginBloc>(context).add(InitLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLYER EATS',
      navigatorKey: navigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)),
      home: LoginNumberPage(),
    );
  }

  void _requestIOSPermissions() {
    FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _showOrderNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Flyer Eats Notifications Channel',
        'Flyer Eats Notifications',
        'Flyer Eats Description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        sound: RawResourceAndroidNotificationSound('new_sound'),
        color: Color(0xFFD82128));
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    AndroidInitializationSettings androidSetting =
        AndroidInitializationSettings('notification_icon');
    IOSInitializationSettings iosSetting = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveOrderNotification);
    InitializationSettings settings =
        InitializationSettings(androidSetting, iosSetting);
    flutterLocalNotificationsPlugin.initialize(settings,
        onSelectNotification: onSelectOrderNotification);
    flutterLocalNotificationsPlugin.show(0, message['notification']['title'],
        message['notification']['body'], platformChannelSpecifics);
  }

  Future onSelectOrderNotification(String payload) async {
    _navigateToActiveOrderPage();
  }

  Future<void> _showCampaignNotification(Map<String, dynamic> message) async {
    var bigPicturePath =
        await _downloadAndSaveFile(message['data']['image'], 'bigPicture');
    var bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        contentTitle: message['notification']['title'],
        summaryText: message['notification']['body'],
        htmlFormatSummaryText: true);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Flyer Eats Campaign Channel',
        'Flyer Eats Campaign',
        'Flyer Eats Description Campaign',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        sound: RawResourceAndroidNotificationSound('new_sound'),
        color: Color(0xFFD82128),
        styleInformation: bigPictureStyleInformation);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    AndroidInitializationSettings androidSetting =
        AndroidInitializationSettings('notification_icon');
    IOSInitializationSettings iosSetting = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveCampaignNotification);
    InitializationSettings settings =
        InitializationSettings(androidSetting, iosSetting);
    flutterLocalNotificationsPlugin.initialize(settings,
        onSelectNotification: onSelectCampaignNotification);
    flutterLocalNotificationsPlugin.show(0, message['notification']['title'],
        message['notification']['body'], platformChannelSpecifics,
        payload: message['data']['order_id']);
  }

  Future onSelectCampaignNotification(String payload) async {
    _navigateToCampaign(payload);
  }

  Future onDidReceiveOrderNotification(
      int id, String title, String body, String payload) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToActiveOrderPage();
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  Future onDidReceiveCampaignNotification(
      int id, String title, String body, String payload) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateToCampaign(payload);
                  },
                  child: Text("OK"))
            ],
          );
        });
  }

  void _navigateToActiveOrderPage() {
    navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
      return TrackOrderPage();
    }));
  }

  void _navigateToCampaign(String campaignId) {
    //for example
    navigatorKey.currentState.push(MaterialPageRoute(builder: (context) {
      return NotificationsListPage();
    }));
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
