import 'package:flutter/material.dart';
import '../screens/profile_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/messages_screen.dart';
import '../widgets/main_drawer.dart';
import '../utilities/constans.dart';
import '../screens/businessbooking_screen.dart';

import '../widgets/custom_bnavigation.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pages;
  bool _middleSelected=false;

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void initState() {
    _pages = [
      {'page': HomeScreen(), 'title': 'Home'},
      {'page': SearchScreen(), 'title': 'Search'},
      {'page': MessagesScreen(), 'title': 'Messages'},
      {'page': ProfileScreen(), 'title': 'Profile'},
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom==0.0;
    return Scaffold(
      appBar: AppBar(title: Text(_pages[_selectedPageIndex]['title']), centerTitle: true, elevation: 0,),
      body: _pages[_selectedPageIndex]['page'],
      drawer: MainDrawer(),
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: 'Bookings',
        color: Colors.grey,
        backgroundColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor,
        notchedShape: CircularOuterNotchedRectangle(),
        onTabSelected: _selectPage,
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: 'Home'),
          FABBottomAppBarItem(iconData: Icons.search, text: 'Search'),
          FABBottomAppBarItem(iconData: Icons.message, text: 'Messages'),
          FABBottomAppBarItem(iconData: Icons.account_circle, text: 'Profile'),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showFab? FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed(BusinessBooking.routeName);
        },  //this will select the center Bookings
        child: Icon(Icons.date_range),
        elevation: 2.0,
        backgroundColor: Theme.of(context).primaryColor,
      ) : null,
    );
  }
}
