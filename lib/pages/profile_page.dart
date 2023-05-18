import 'dart:convert';
import 'package:diploma/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late SharedPreferences _prefs;
  bool _isLoading = true;
  Map<String, dynamic>? _userProfile;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('http://34.116.195.230:9000/api/auth/me');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        setState(() {
          _userProfile = responseJson;
          _isLoading = false;
        });
      } else {
        print(response.statusCode);
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading user profile: ${e.toString()}';
      });
      print(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _userProfile == null
          ? const Center(
        child: Text('Failed to load user profile'),
      )
          : Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              child: Text(
                (_userProfile?['firstName'] ?? '') +
                    ' ' +
                    (_userProfile?['lastName'] ?? '') +
                    ' ' +
                    (_userProfile?['patronymic'] ?? ''),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.phone, color: Colors.white),
              title: Text(
                _userProfile!['phone'],
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.email, color: Colors.white),
              title: Text(
                _userProfile!['email'] ?? 'No email provided',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Log out'),
              onPressed: () async {
                _prefs = await SharedPreferences.getInstance();
                final token = _prefs.getString('token');
                final response = await http.post(
                  Uri.parse(
                      'http://34.116.195.230:9000/api/auth/logout'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer $token',
                  },
                );

                if (response.statusCode == 200) {
                  await _prefs.remove('token');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()),
                  );
                } else {
                  // handle the error response
                  throw Exception('Failed to log out');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}