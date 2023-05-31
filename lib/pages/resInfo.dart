import 'package:flutter/material.dart';
import 'package:diploma/pages/restaurantPage.dart';
import 'package:diploma/pages/bookSeats.dart';
import 'package:diploma/pages/cartPage.dart'; // Import the CartPage
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantInfoPage extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantInfoPage({required this.restaurant});

  @override
  _RestaurantInfoPageState createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {
  bool _isLoading = false;
  String _errorMessage = '';
  String _name = '';
  String _description = '';
  int _seats = 0;
  String _image = '';

  @override
  void initState() {
    super.initState();
    fetchRestaurantData();
  }

  Future<void> fetchRestaurantData() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://34.116.195.230:9001/api/restaurant/${widget.restaurant.id}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final restaurantData = json.decode(response.body);

        if (restaurantData != null && restaurantData['data'] != null) {
          final data = restaurantData['data'];

          _name = data['name'] ?? '';
          _description = data['description'] ?? '';
          _seats = data['seats'] ?? 0;
          _image = data['image'] ?? '';
        } else {
          throw Exception('Invalid restaurant data');
        }
      } else {
        throw Exception('Failed to fetch restaurant data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading restaurant data: ${e.toString()}';
      });
      print(_errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : _errorMessage.isNotEmpty
            ? Center(
          child: Text(_errorMessage),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(_description),
            SizedBox(height: 16),
            const Text(
              'Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            //Text(restaurant.location),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantMenuPage(restaurant: widget.restaurant),
                        ),
                      );
                    },
                    child: const Text('View Menu'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookTablePage(cartItems: [], restaurantId: widget.restaurant.id),
                        ),
                      );
                    },
                    child: const Text('Book table'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (_image.isNotEmpty)
              Image.network(
                _image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(restaurantId: widget.restaurant.id), // Pass the restaurant ID to CartPage
            ),
          );
        },
        icon: Icon(Icons.shopping_cart),
        label: Text('View Cart'),
      ),
    );
  }
}