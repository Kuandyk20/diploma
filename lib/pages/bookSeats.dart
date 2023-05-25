import 'package:flutter/material.dart';

class Seat {
  final int number;
  final bool isFree;

  Seat(this.number, this.isFree);
}

class BookingSeatsPage extends StatefulWidget {
  @override
  _BookingSeatsPageState createState() => _BookingSeatsPageState();
}

class _BookingSeatsPageState extends State<BookingSeatsPage> {
  List<Seat> _seats = List.generate(30, (index) => Seat(index + 1, true));
  List<int> _selectedSeatNumbers = [];
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now(); // Initialize with current date and time
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats'),
      ),
      body: Column(
        children: [
      Expanded(
      child: Center(
      child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 6,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemBuilder: (context, index) {
        final seat = _seats[index];
        return GestureDetector(
          onTap: () {
            if (!seat.isFree) {
              return;
            }
            setState(() {
              if (_selectedSeatNumbers.contains(seat.number)) {
                _selectedSeatNumbers.remove(seat.number);
              } else {
                _selectedSeatNumbers.add(seat.number);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: !seat.isFree && _selectedSeatNumbers.contains(seat.number)
                  ? Colors.red
                  : seat.isFree && _selectedSeatNumbers.contains(seat.number)
                  ? Colors.blue
                  : !seat.isFree
                  ? Colors.grey
                  : Colors.white,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Center(
              child: Text(
                '${seat.number}',
                style: TextStyle(
                  color: !seat.isFree && _selectedSeatNumbers.contains(seat.number)
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
      itemCount: _seats.length,
      padding: EdgeInsets.all(10.0),
    ),
    ),
    ),
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Date',
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    ),
    ),
    SizedBox(height: 8.0),
    ElevatedButton(
    onPressed: () async {
    final selectedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
    setState(() {
    _selectedDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    _selectedDateTime?.hour ?? 0,
    _selectedDateTime?.minute ?? 0,
    );
    });
    }
    },
    child: Text(
    _selectedDateTime == null
    ? 'Select date'
        : '${_selectedDateTime.year}-${_selectedDateTime.month}-${_selectedDateTime.day}',
    ),
    ),
    ],
    ),
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    'Time',
    style: TextStyle(
    fontWeight: FontWeight.w100,
      fontSize: 16.0,
    ),
    ),
      SizedBox(height: 8.0),
      ElevatedButton(
        onPressed: () async {
          final selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (selectedTime != null) {
            setState(() {
              _selectedDateTime = DateTime(
                _selectedDateTime?.year ?? DateTime.now().year,
                _selectedDateTime?.month ?? DateTime.now().month,
                _selectedDateTime?.day ?? DateTime.now().day,
                selectedTime.hour,
                selectedTime.minute,
              );
            });
          }
        },
        child: Text(
          _selectedDateTime == null
              ? 'Select time'
              : '${_selectedDateTime.hour}:${_selectedDateTime.minute}',
        ),
      ),
    ],
    ),
    ],
    ),
    ),
          SizedBox(height: 16.0, width: 20.0,),
          ElevatedButton(
            onPressed: _selectedSeatNumbers.isNotEmpty && _selectedDateTime != null
                ? () {
              // Handle booking logic here
            }
                : null,
            child: Text('Book Seats'),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}