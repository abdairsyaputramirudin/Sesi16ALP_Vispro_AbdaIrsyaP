import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../providers/order_provider.dart';

class PaymentScreen extends StatelessWidget {
  final double totalAmount;
  final OrderProvider orderProvider;
  final List<CartItem> items;
  final String tableId;
  final String customerName;
  final String phoneNumber;
  final String note;

  PaymentScreen({
    required this.totalAmount,
    required this.orderProvider,
    required this.items,
    required this.tableId,
    required this.customerName,
    required this.phoneNumber,
    required this.note,
  });

  void _showConfirmationDialog(BuildContext context, String paymentMethod) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Konfirmasi Pembayaran"),
        content: Text("Anda memilih pembayaran $paymentMethod. Lanjutkan?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close the dialog
              await orderProvider.confirmAndAddOrder(
                tableId: tableId,
                items: items,
                totalPrice: totalAmount,
                customerName: customerName,
                phoneNumber: phoneNumber,
                note: note,
              );
              Navigator.pushNamed(context, '/invoice', arguments: {
                'totalPrice': totalAmount,
                'customerName': customerName,
                'tableId': tableId,
                'items': items.map((item) => item.toMap()).toList(),
                'note': note,
              });
            },
            child: Text("Lanjutkan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title:
            Text("Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Total Pembayaran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Rp $totalAmount",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Pilih Metode Pembayaran:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _showConfirmationDialog(context, "Tunai"),
              child: Text(
                "Tunai",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => _showConfirmationDialog(context, "Online"),
              child: Text(
                "Online",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
