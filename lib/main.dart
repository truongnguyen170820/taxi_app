import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taxi_app/blocs/auth_bloc.dart';
import 'package:taxi_app/my_app.dart';
import 'package:taxi_app/resources/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(
    new AuthBloc(),
    MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget child) {
        final data = MediaQuery.of(context).copyWith(textScaleFactor: 1.0);
        return MediaQuery(data: data, child: child);
      },
      home: LoginPage(),
    ))
  );
}


