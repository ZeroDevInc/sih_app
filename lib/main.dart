import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sih_app/api/api.dart';
import 'package:sih_app/helpers/navigator_helper.dart';
import 'package:sih_app/utils/components/bottomNav.dart';
import 'package:sih_app/views/login/pages/login_page.dart';
import 'package:sih_app/views/map/maps.dart';
import 'package:sih_app/views/map/mapscreen.dart';

import 'package:sih_app/views/register/pages/registration_page.dart';

final auth = FirebaseAuth.instance;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    pushtoHome(BuildContext context) async {
      final locations = await API().getAllParkings();
      print(locations);
      List<dynamic> jsonList = jsonDecode(locations);

      List<Map<String, dynamic>> mapsList =
          List<Map<String, dynamic>>.from(jsonList);
      if (context.mounted) {
        NavigationHelper.navigateToSecondRoute(context, MapScreen());
      }
    }

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.black),
          ),
          primarySwatch: Colors.yellow,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white, //<-- SEE HERE
          ),
        ),
        home: auth.currentUser == null ? LoginPage() : MapScreen());
  }
}
