// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'edit_item_page.dart';

class EditItemPage extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditItemPage({super.key, required this.item});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  bool? _isChecked; // Store checkbox state

  @override
  void initState() {
    super.initState();
    // Initialize checkbox state from the item data
    _isChecked = widget.item['isChecked'];
  }

  void _saveChanges() {
    widget.item['isChecked'] = _isChecked;
    Navigator.pop(context, widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asset : ${widget.item['name']}',
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w200,
              color: Color.fromARGB(255, 245, 255, 198)),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 0, 43),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 245, 255, 198), // Color of the back button
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Text for productId
                _buildTextItem('ProductId', widget.item['productId']),
                // Display Text for name
                _buildTextItem('Name', widget.item['name']),
                // Display Text for location
                _buildTextItem('Location', widget.item['location']),
                // Display Text for price
                _buildTextItem('Price', widget.item['price'].toString()),
                // Display Text for serial
                _buildTextItem('Serial', widget.item['serial']),
                // Display Text for orderDate
                _buildTextItem(
                    'OrderDate', widget.item['orderDate'].toString()),
                // Display Text for poNo
                _buildTextItem('PoNo', widget.item['poNo']),
                // Display Text for remark
                _buildTextItem('Remark', widget.item['remark']),
                const Divider(height: 32.0),
                // Button to navigate to edit location and remark
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final newLocationRemark = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditLocationPage(
                            initialLocation: widget.item['location'],
                            initialRemark: widget.item['remark'],
                          ),
                        ),
                      );
                      if (newLocationRemark != null && mounted) {
                        setState(() {
                          widget.item['location'] =
                              newLocationRemark['location'];
                          widget.item['remark'] = newLocationRemark['remark'];
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Update'),
                  ),
                ),
                CheckboxListTile(
                  title: const Text('Checked'),
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create a styled Text widget
  Widget _buildTextItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
