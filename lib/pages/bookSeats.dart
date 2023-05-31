import 'package:diploma/pages/restaurantPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookTablePage extends StatefulWidget {
  final int restaurantId;
  final List<MenuItem> cartItems;

  const BookTablePage({
    required this.restaurantId,
    required this.cartItems,
  });

  @override
  _BookTablePageState createState() => _BookTablePageState();
}

class _BookTablePageState extends State<BookTablePage> {
  final TextEditingController guestsController = TextEditingController();
  DateTime? selectedStartTime;
  DateTime? selectedEndTime;

  Future<void> bookTable() async {
    if (selectedStartTime == null || selectedEndTime == null) {
      // Start time or end time not selected, show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select a start time and end time.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final url = Uri.parse('http://34.116.195.230:9001/api/booking');

    final bookingData = {
      "restaurantId": widget.restaurantId,
      "timeStart": '${selectedStartTime!.toIso8601String().substring(0,19)}Z',
      "timeEnd": '${selectedEndTime!.toIso8601String().substring(0,19)}Z',
      "guests": int.parse(guestsController.text),
      "preorder": widget.cartItems
          .map((item) => {"itemId": item.id, "quantity": item.quantity})
          .toList(),
    };
    print(bookingData);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(url, body: jsonEncode(bookingData), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    print(response);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final data = responseData['data'];
      final stripeUrl = data['stripeUrl'];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(url: stripeUrl)),
      );
      // Use the stripeSessionId as needed
      print('Stripe Session ID: $stripeUrl');
    } else {
      // Booking failed
      // Do something, such as showing an error message
      print(response.statusCode);
    }
  }

  Future<void> selectStartTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          selectedStartTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<void> selectEndTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          selectedEndTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Number of Guests',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: guestsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter number of guests',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: selectStartTime,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: selectedStartTime != null
                              ? selectedStartTime!.toString()
                              : '',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Select start time',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: selectEndTime,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: selectedEndTime != null
                              ? selectedEndTime!.toString()
                              : '',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Select end time',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            const Text(
              'Preorder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return ListTile(
                  title: Text(item.name),
                );
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  bookTable();
                },
                child: Text('Book Table'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Payment'),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted, // This line enables JavaScript
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
        },
      )
    );
  }
}