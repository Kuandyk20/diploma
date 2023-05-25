import 'package:diploma/pages/profile_page.dart';
import 'package:diploma/pages/support.dart';
import 'package:flutter/material.dart';
import 'restaurantPage.dart';
import 'package:diploma/pages/cartPage.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  final List<Widget> _children = [RestaurantListPage(), UserProfilePage(), SupportPage(), CartPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OurApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _children,
          ),
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 30,
            type: BottomNavigationBarType.fixed,
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black26,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.support),
                label: 'Support',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
            ],
          ),
        )
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
