import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/profile_screen.dart';
import './screens/booking_screen.dart';
import './screens/home_screen.dart';
import './screens/search_screen.dart';
import './screens/messages_screen.dart';
import './screens/filter_screen.dart';
import './screens/detail_screen.dart';
import './screens/businessbooking_screen.dart';


import './widgets/main_drawer.dart';
import './utilities/constans.dart';
import './screens/tabs_screen.dart';
import './widgets/onlycustomer/c_editprofile.dart';
import './widgets/onlyservice/s_editprofile.dart';
import './screens/search_map_screen.dart';

import './providers/currentuser.dart';

void main() {
  runApp(MyApp());
}

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => CurrentUser(),
          ),
        ],
        child: MaterialApp(
          title: 'Beauty',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red, //
            accentColor: Colors.amber[50],
            buttonColor: Color(0xFF527DAA), //button text color
            primaryColor: Color(0xFFF8B195),
          ),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (ctx, usersnapShot) {
                if (usersnapShot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (usersnapShot.hasData) {
                  return TabScreen();
                }
                return AuthScreen();
              }),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            BookingScreen.routeName: (ctx) => BookingScreen(),
            MessagesScreen.routeName: (ctx) => MessagesScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            CEditProfile.routeName: (ctx)=> CEditProfile(),
            //SEditProfile.routeName: (ctx)=> SEditProfile(),
            SearchMapScreen.routeName: (ctx)=>SearchMapScreen(),
            FilterScreen.routename: (ctx)=>FilterScreen(),
            DetailScreen.routeName: (ctx)=>DetailScreen(),
            BusinessBooking.routeName: (ctx)=>BusinessBooking(),
          },
        ));
  }
}
