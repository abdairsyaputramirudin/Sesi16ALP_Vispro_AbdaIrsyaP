import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/table_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedTable;
  final TableService _tableService = TableService();

  void _selectTable(int tableNumber) async {
    bool isTableAvailable =
        await _tableService.isTableAvailable("table_$tableNumber");

    if (isTableAvailable) {
      setState(() {
        _selectedTable = tableNumber;
      });
      // Navigasi langsung ke halaman berikutnya setelah double-tap meja
      _navigateToCustomerInfo();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Meja ini sudah ditempati, pilih meja lain atau minta admin untuk reset.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToCustomerInfo() {
    if (_selectedTable != null) {
      Navigator.pushNamed(
        context,
        '/customer-info',
        arguments: {
          'tableId': "table_$_selectedTable",
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Pilih Meja atau Login Admin",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Icon(FontAwesomeIcons.utensils),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Silakan pilih meja yang tersedia:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(5, (index) {
                int tableNumber = index + 1;
                return GestureDetector(
                  onDoubleTap: () => _selectTable(tableNumber),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.chair,
                            color: Colors.green[700],
                            size: 24,
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Meja $tableNumber",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/admin-login'),
              icon: Icon(FontAwesomeIcons.userShield, size: 18),
              label: Text("Login sebagai Admin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
