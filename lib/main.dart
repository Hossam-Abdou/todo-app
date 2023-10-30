import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Todo_app/screens/todo_layout.dart';

import 'bloc.dart';

void main() {

   Bloc.observer=MyBlocObserver();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(


      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.black
        ),
        scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueGrey
          ),

        appBarTheme: AppBarTheme(

              backgroundColor: Colors.blueGrey,
              titleTextStyle: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),
              systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness:Brightness.light ,
                statusBarColor: Colors.grey, ),
               elevation: 0.0,
            ),

      ),

      home:HomeLayout(),


    );
  }
}
