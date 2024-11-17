import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For token storage
import 'dart:convert';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  final Dio dio = Dio(); // Use Dio instance for network calls
  final String baseUrl = 'http://localhost:8080'; // Backend URL

  // Fungsi untuk memperbarui profil
  Future<void> updateProfile(String name) async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    // Retrieve token from SharedPreferences (or another place you store it)
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token'); // Adjust the key to match your storage logic

    if (token == null || token.isEmpty) {
      setState(() {
        _message = 'No authentication token found';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await dio.patch(
        '$baseUrl/account/update',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': token,  // Use the token in the header
          },
        ),
        data: jsonEncode({'name': name}), // Send data as JSON
      );

      if (response.statusCode == 200) {
        setState(() {
          _message = 'Profile updated successfully!';
          _isLoading = false;
        });
      } else {
        setState(() {
          _message = 'Failed to update profile: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error updating profile: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Your Profile',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
          ),
          const SizedBox(height: 20),

          // Name input field
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Save changes button
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                updateProfile(_nameController.text);
              } else {
                setState(() {
                  _message = 'Please enter your name';
                });
              }
            },
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),

          // Display message after request
          if (_message.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                _message,
                style: TextStyle(
                  color: _message.startsWith('Error') ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
