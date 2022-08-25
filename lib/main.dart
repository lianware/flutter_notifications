import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            playSound: false,
            enableVibration: false,
            importance: NotificationImportance.Min)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String token1;

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    FirebaseMessaging.instance.getToken().then((token) {
      print("token is ${token}");
      token1 = token!;
      setState(() {});
    });
  }

  void showLocalNotification(RemoteMessage message) async {
    bool isallowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isallowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      //show notification
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 349046,
              channelKey: 'basic',
              title: message.notification!.title.toString(),
              body: message.notification!.body.toString(),
              color: Colors.grey));
    }
  }

  static const input_title = TextStyle(
    color: Colors.blueAccent,
    fontSize: 16,
    fontWeight: FontWeight.w800,
  );

  static const hint_text = TextStyle(
    color: Colors.black45,
    fontSize: 14,
  );

  var _titleController = TextEditingController();
  var _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Notification"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TextField(
                  controller: _titleController,
                  textAlign: TextAlign.center,
                  style: input_title,
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: hint_text,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TextField(
                  controller: _bodyController,
                  textAlign: TextAlign.center,
                  style: input_title,
                  decoration: InputDecoration(
                    hintText: "Body",
                    hintStyle: hint_text,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  getQue(_titleController.text, _bodyController.text);
                  FirebaseMessaging.onMessage.listen((RemoteMessage Payam) {
                    showLocalNotification(Payam);
                  });
                },
                child: Text(
                  "Send a Notification",
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fixedSize: Size(340, 60),
                  primary: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  elevation: 10,
                  textStyle: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getQue(String title, String body) async {
    Response response = await post(Uri.parse("http://185.110.190.182/"),
        body: {'token': token1, 'body': body, 'title': title});
    return response.body;
  }
}
