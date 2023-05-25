import 'package:flutter/material.dart';
import 'package:diploma/pages/restaurantPage.dart';

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
            const Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(restaurant.description),
            SizedBox(height: 16),
            const Text(
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
                      builder: (context) => RestaurantMenuPage(restaurant: restaurant),
                    ),
                  );
                },
                child: const Text('View Menu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
