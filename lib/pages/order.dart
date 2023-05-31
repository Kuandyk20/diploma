import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*
class BookingsPage extends StatefulWidget {
  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  //List<Booking> _bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final response =
    await http.get(Uri.parse('http://34.116.195.230:9001/api/booking'));

    if (response.statusCode == 200) {
      List<Booking> bookings = (json.decode(response.body)['content'] as List)
          .map((i) => Booking.fromJson(i))
          .toList();

      setState(() {
        _bookings = bookings;
      });
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_bookings[index].restaurantName),
            subtitle: Text(
                'From: ${_bookings[index].startTime}\nTo: ${_bookings[index].endTime}'),
          );
        },
      ),
    );
  }
}
*/