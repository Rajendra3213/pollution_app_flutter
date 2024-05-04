import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _passwordError;
  String? _phoneNumberError;
  String? _emailError;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                  errorText: _emailError,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  errorText: _passwordError,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                  errorText: _phoneNumberError,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : () => _signup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 5,
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String phoneNumber = _phoneNumberController.text;
    String address = _addressController.text;
    int age = int.tryParse(_ageController.text) ?? 0;

    // Your backend API endpoint for signup
    String url = '$baseUrl/api/users/register/';

    setState(() {
      _passwordError = null;
      _phoneNumberError = null;
      _emailError = null;
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
          'address': address,
          'age': age,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        // Successful signup
        final data = jsonDecode(response.body);
        final details = data['detail'] as String;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(details),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          elevation: 5,
        ));
        Navigator.pop(context);
      } else if (response.statusCode == 422) {
        final data = jsonDecode(response.body);
        final errors = data['detail'] as List<dynamic>;

        for (final error in errors) {
          final field = error['loc'][2] as String;
          final message = error['msg'] as String;

          if (field == 'password') {
            setState(() {
              _passwordError = message;
            });
          } else if (field == 'phone_number') {
            setState(() {
              _phoneNumberError = message;
            });
          }
          else if (field == 'email') {
            setState(() {
              _emailError = message;
            });
          }
        }
      } else {
        final data = jsonDecode(response.body);
        final details = data['detail'] as String;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(details),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
          elevation: 5,
        ));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error: $e');
    }
  }
}