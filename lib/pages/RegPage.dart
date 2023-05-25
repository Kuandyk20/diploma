import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'loginPage.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();

}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final NavigatorState _navigator;

  Future<void> _navigateToHome() async {
    await Future.delayed(Duration(seconds: 1));
    _navigator.pushReplacementNamed('/');
  }

  final _formKey = GlobalKey<FormState>();
  String _firstname = '';
  String _lastname = '';
  String _patronymic = '';
  String _phone = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _errorMessage = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final url = Uri.parse('http://34.116.195.230:9000/api/auth/register');
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({
        'firstName': _firstname,
        'lastName': _lastname,
        'patronymic': _patronymic,
        'phone': _phone,
        'email': _email,
        'password': _password,
      });

      try {
        final response = await http.post(url, headers: headers, body: body);
        final responseData = json.decode(response.body);

        if (response.statusCode == 200) {
          print('Chukumba');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          setState(() {
            _errorMessage = responseData['message'] ?? 'Registration failed';
          });
          print(_errorMessage);
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Registration failed: ${e.toString()}';
          print(_errorMessage);
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register your Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'First Name *'),
                  validator: (value) {
                    final RegExp lettersOnlyRegex = RegExp(r'^[a-zA-Z]+$');
                    if (value!.isEmpty) {
                      return 'Please enter your first name';
                    } else if (!lettersOnlyRegex.hasMatch(value)) {
                      return 'Please enter a valid first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstname = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Last Name *'),
                  validator: (value) {
                    final RegExp lettersOnlyRegex = RegExp(r'^[a-zA-Z]+$');
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    } else if (!lettersOnlyRegex.hasMatch(value)) {
                      return 'Please enter a valid last name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastname = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Patronymic'),
                  validator: (value){
                    final RegExp lettersOnlyRegex = RegExp(r'^[a-zA-Z]+$');
                    if (!lettersOnlyRegex.hasMatch(value!)) {
                      return 'Please enter a valid patronymic';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _patronymic = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone Number *'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    final RegExp regex = RegExp(r'^\+?\d{9,15}$');
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!regex.hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _phone = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onSaved: (value) {
                    _email = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password *'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Register'),
                ),
                TextButton(
                  child: const Text('Log In'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}