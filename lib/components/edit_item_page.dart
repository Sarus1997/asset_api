// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

class EditLocationPage extends StatefulWidget {
  final String? initialLocation;
  final String? initialRemark;

  const EditLocationPage({super.key, this.initialLocation, this.initialRemark});

  @override
  _EditLocationPageState createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  late TextEditingController _locationController;
  late TextEditingController _remarkController;

  @override
  void initState() {
    super.initState();
    _locationController =
        TextEditingController(text: widget.initialLocation ?? '');
    _remarkController = TextEditingController(text: widget.initialRemark ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: Color.fromARGB(255, 245, 255, 198)),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 0, 43),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 245, 255, 198), // Color of the back button
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _remarkController,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'location': _locationController.text,
                    'remark': _remarkController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Save', style: TextStyle(fontSize: 16.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    _remarkController.dispose();
    super.dispose();
  }
}
