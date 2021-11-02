import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(handleMessage);

  runApp(MyApp());
}

String messageTitle = 'Empty';
String notificationAlert = 'Alert';

Future<void> handleMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Background message is :${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  late FirebaseMessaging messaging;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Exercise Day 7'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      print('Token is $value');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      setState(() {
        notificationAlert = event.notification!.title.toString();
        messageTitle = event.notification!.body.toString();
      });
      print('message received');
      print('Message is :${event.notification!.body}');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Notification Form Firebase'),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('Notification is clicked');
    });
  }

  

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              notificationAlert,
            ),
            Text(
              messageTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
