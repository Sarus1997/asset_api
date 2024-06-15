// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'edit_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class SearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onScanQRCode;
  final VoidCallback onResetPage;
  final VoidCallback onShowChecked;
  final VoidCallback onToggleFilter;
  final AnimationController animationController;

  const SearchBar({
    required this.controller,
    required this.onTextChanged,
    required this.onScanQRCode,
    required this.onResetPage,
    required this.onShowChecked,
    required this.onToggleFilter,
    required this.animationController,
    super.key,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _isPfPressed = false;
  bool _isNfPressed = false;
  final Duration animationDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 235, 229, 229),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Search',
                hintText: 'ค้นหา',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: widget.onScanQRCode,
                ),
              ),
              style: const TextStyle(color: Colors.blue),
              onChanged: widget.onTextChanged,
            ),
          ),
        ),
        IconButton(
          icon: RotationTransition(
            turns:
                Tween(begin: 0.0, end: 1.0).animate(widget.animationController),
            child: const Icon(Icons.refresh, color: Colors.purple),
          ),
          onPressed: () {
            widget.animationController.forward(from: 0.0);
            widget.onResetPage();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              _buildFilterButton('PF', _isPfPressed, () {
                setState(() {
                  _isPfPressed = !_isPfPressed;
                  if (_isPfPressed) {
                    _isNfPressed = false;
                  }
                });
                widget.onShowChecked();
              }),
              const SizedBox(width: 8),
              _buildFilterButton('NF', _isNfPressed, () {
                setState(() {
                  _isNfPressed = !_isNfPressed;
                  if (_isNfPressed) {
                    _isPfPressed = false;
                  }
                });
                widget.onToggleFilter();
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label, bool isSelected, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: animationDuration,
          width: isSelected ? 40 : 30,
          height: isSelected ? 40 : 30,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.grey[100],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: isSelected ? 15 : 13),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  bool _isFiltered = false;
  bool _showCheckedOnly = false;
  String _searchText = '';

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _loadItems();
  }

  Future<void> _loadItems() async {
    List<Map<String, dynamic>> loadedItems = await _loadItemsFromJson();
    setState(() {
      items = loadedItems;
    });
  }

  Future<List<Map<String, dynamic>>> _loadItemsFromJson() async {
    final String response =
        await rootBundle.loadString('assets/database/items.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) {
      item['orderDate'] = DateTime.parse(item['orderDate']);
      return item as Map<String, dynamic>;
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredItems {
    List<Map<String, dynamic>> filteredList = items;

    if (_isFiltered) {
      filteredList = filteredList
          .where((item) => item['isChecked'] == _showCheckedOnly)
          .toList();
    }

    if (_searchText.isNotEmpty) {
      filteredList = filteredList.where((item) {
        String searchTextLowerCase = _searchText.toLowerCase();
        return item['productId']
                .toString()
                .toLowerCase()
                .contains(searchTextLowerCase) ||
            item['name']
                .toString()
                .toLowerCase()
                .contains(searchTextLowerCase) ||
            item['price']
                .toString()
                .toLowerCase()
                .contains(searchTextLowerCase) ||
            item['location']
                .toString()
                .toLowerCase()
                .contains(searchTextLowerCase);
      }).toList();
    }

    return filteredList;
  }

  void _onTextChanged(String text) {
    setState(() {
      _searchText = text;
    });
  }

  void _resetPage() {
    _controller.clear();
    setState(() {
      _isFiltered = false;
      _showCheckedOnly = false;
      _searchText = '';
    });
  }

  void _toggleFilter() {
    setState(() {
      _isFiltered = !_isFiltered;
      if (!_isFiltered) {
        _showCheckedOnly = false;
      }
    });
  }

  void _showChecked() {
    setState(() {
      _isFiltered = true;
      _showCheckedOnly = true;
    });
  }

  void _scanQRCode() {
    // Logic to scan QR code
  }

  int get totalAmount {
    return items.fold(0, (sum, item) => sum + (item['price'] as int));
  }

  int get checkedItemsCount {
    return items.where((item) => item['isChecked'] == true).length;
  }

  int get totalItemsCount {
    return items.length;
  }

  String get formattedAmount {
    final formatter =
        NumberFormat.currency(locale: 'th', symbol: '฿', decimalDigits: 0);
    return formatter.format(totalAmount);
  }

  Widget _buildAppBarActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Balance: $formattedAmount',
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 245, 255, 198),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'PF: $checkedItemsCount / $totalItemsCount',
            style: const TextStyle(
              fontSize: 13,
              color: Color.fromARGB(255, 245, 255, 198),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'API',
          style: TextStyle(
            color: Color.fromARGB(255, 245, 255, 198),
            fontSize: 16,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 19, 0, 43),
        actions: [
          _buildAppBarActions(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SearchBar(
              controller: _controller,
              onTextChanged: _onTextChanged,
              onScanQRCode: _scanQRCode,
              onResetPage: _resetPage,
              onShowChecked: _showChecked,
              onToggleFilter: _toggleFilter,
              animationController: _animationController,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              '${item['productId']} - ${item['name']}',
                              style: const TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green[700]!,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.green[50],
                            ),
                            child: Text(
                              '฿${item['price']}',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: item['isChecked']
                              ? Colors.green[100]
                              : Colors.red[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['isChecked'] ? Icons.check_circle : Icons.cancel,
                          color: item['isChecked'] ? Colors.green : Colors.red,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditItemPage(item: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
