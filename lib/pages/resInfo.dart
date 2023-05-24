import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:diploma/pages/restaurantPage.dart';
import 'dart:convert';


import 'bookSeats.dart';

class RestaurantInfoPage extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantInfoPage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(restaurant.description),
            SizedBox(height: 16),
            Text(
              'Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            //Text(restaurant.location),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantMenuPage(
                        restaurant: restaurant,
                      ),
                    ),
                  );
                },
                child: Text('View Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantMenuPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantMenuPage({required this.restaurant});

  @override
  _RestaurantMenuPageState createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  List<MenuItem> menuItems = [];
  int? selectedItemId; // Variable to store the selected item ID

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    final response = await http.get(
      Uri.parse(
          'http://34.116.195.230:9001/api/restaurant/${widget.restaurant
              .id}/menu'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final menuData = data['data']['menuItems'] as List<dynamic>;
      final fetchedMenu = menuData
          .map((menuData) => MenuItem.fromJson(menuData))
          .toList();

      setState(() {
        menuItems = fetchedMenu;
      });
    } else {
      throw Exception('Failed to fetch menu');
    }
  }

  void handleMenuItemTap(MenuItem menuItem) {
    setState(() {
      selectedItemId = menuItem.id;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookSeatsPage(
          restaurant: widget.restaurant,
          menuItem: menuItem,
          selectedItemId: selectedItemId!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.restaurant.name),
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            )
        )
    );
  }
}
