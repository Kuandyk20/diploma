import 'package:diploma/pages/restaurantPage.dart';
import 'package:flutter/material.dart';

class BookSeatsPage extends StatefulWidget {
  final Restaurant restaurant;
  final MenuItem menuItem;
  final int selectedItemId;

  const BookSeatsPage({
    required this.restaurant,
    required this.menuItem,
    required this.selectedItemId,
  });

  @override
  _BookSeatsPageState createState() => _BookSeatsPageState();
}

class _BookSeatsPageState extends State<BookSeatsPage> {
  int numberOfSeats = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Seats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant: ${widget.restaurant.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Selected Item: ${widget.menuItem.name}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Enter the number of seats you want to book:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  numberOfSeats = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                hintText: 'Number of seats',
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add your logic to book seats here
                  // Access the selected restaurant, menu item, and number of seats using widget.restaurant, widget.menuItem, and numberOfSeats variables
                },
                child: Text('Book'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}