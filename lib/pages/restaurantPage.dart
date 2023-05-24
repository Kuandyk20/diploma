import 'package:diploma/pages/resInfo.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'bookSeats.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  List<Restaurant> restaurants = [];
  List<Restaurant> filteredRestaurants = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRestaurants();
  }

  Future<void> fetchRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('http://34.116.195.230:9001/api/restaurant/list');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final restaurantsData = data['content'] as List<dynamic>;
      final fetchedRestaurants = restaurantsData
          .map((restaurantData) => Restaurant.fromJson(restaurantData))
          .toList();
      setState(() {
        restaurants = fetchedRestaurants;
        filteredRestaurants = fetchedRestaurants;
      });
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  void filterRestaurants(String searchTerm) {
    setState(() {
      filteredRestaurants = restaurants
          .where((restaurant) =>
          restaurant.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Restaurants'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: RestaurantSearchDelegate(restaurants),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF398AE5), Color(0xFF67B5F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: filteredRestaurants.length,
          itemBuilder: (BuildContext context, int index) {
            final restaurant = filteredRestaurants[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Icon(Icons.restaurant),
                title: Text(
                  restaurant.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text(restaurant.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantInfoPage(restaurant: restaurant),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Restaurant {
  final int id;
  final String name;
  final String description;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}

class MenuItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final List<String> images;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as double?) ?? 0.0,
      images: (json['images'] as List<dynamic>).cast<String>(),
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

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    final response = await http.get(
        Uri.parse('http://34.116.195.230:9001/api/restaurant/${widget.restaurant.id}/menu'));
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
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: menuItems.length,
          itemBuilder: (BuildContext context, int index) {
            final menuItem = menuItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookSeatsPage(
                      restaurant: widget.restaurant,
                      menuItem: menuItem,
                      selectedItemId: menuItem.id,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0),
                        ),
                        child: Image.network(
                          menuItem.images[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        menuItem.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'Price: \$${menuItem.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RestaurantSearchDelegate extends SearchDelegate<Restaurant?> {
  final List<Restaurant> restaurants;

  RestaurantSearchDelegate(this.restaurants);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = restaurants
        .where((restaurant) =>
        restaurant.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        final restaurant = searchResults[index];
        return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
        colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        ),
        ),
        child: ListTile(
        contentPadding:
        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: Icon(Icons.restaurant, color: Colors.white),
        title: Text(
        restaurant.name,
        style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: Colors.white,
        ),
        ),
        subtitle: Text(
        restaurant.description,
        style: TextStyle(
        color: Colors.white,
        ),
        ),
        onTap: () {
        close(context, restaurant);
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) =>
        RestaurantMenuPage(restaurant: restaurant),
        ),
        );
        },
        ),
        ),
        ),
        )
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = restaurants
        .where((restaurant) =>
        restaurant.name.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        final restaurant = suggestionList[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            color: Colors.transparent,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: const Icon(
                Icons.restaurant,
                color: Colors.white,
              ),
              title: Text(
                restaurant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                restaurant.description,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                close(context, restaurant);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RestaurantInfoPage(restaurant: restaurant),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}