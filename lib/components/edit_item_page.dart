// ignore_for_file: library_private_types_in_public_api

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
        title: const Text('Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _remarkController,
              decoration: const InputDecoration(
                labelText: 'Remark',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
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
              child: const Text('Save'),
            ),
          ],
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
