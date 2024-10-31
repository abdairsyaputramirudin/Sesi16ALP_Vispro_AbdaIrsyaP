import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text(
          "Admin - Daftar Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Belum ada pesanan."));
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: orders.length,
            itemBuilder: (ctx, i) {
              var order = orders[i];
              var orderData = order.data() as Map<String, dynamic>;
              var status = orderData['status'] ?? 'pending';
              var items = orderData['items'] as List<dynamic>;
              var tableId = orderData['tableId'] ?? 'N/A';
              var orderTime = orderData['createdAt'] != null
                  ? (orderData['createdAt'] as Timestamp).toDate()
                  : 'N/A';
              var customerName = orderData['customerName'] ?? 'N/A';
              var totalPrice = orderData['totalPrice'] ?? 'N/A';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    "Meja: $tableId - $customerName",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Waktu: ${orderTime.toString().substring(0, 16)} - Status: $status",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: Icon(
                    status == 'pending'
                        ? Icons.pending
                        : status == 'sedang disiapkan'
                            ? Icons.restaurant_menu
                            : Icons.check_circle,
                    color: status == 'pending'
                        ? Colors.red
                        : status == 'sedang disiapkan'
                            ? Colors.orange
                            : Colors.green,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            "Daftar Item:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          ...items.map((item) {
                            return ListTile(
                              title: Text(item['name'] ?? 'Unknown Item'),
                              subtitle: Text("Jumlah: ${item['quantity']}"),
                              trailing: Text("Rp ${item['price']}"),
                            );
                          }).toList(),
                          ListTile(
                            title: Text("Total Harga",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            trailing: Text(
                              "Rp $totalPrice",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _showUpdateStatusDialog(
                                  context, order.id, status),
                              child: Text("Perbarui Status"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUpdateStatusDialog(
      BuildContext context, String orderId, String currentStatus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Perbarui Status"),
        content: DropdownButtonFormField<String>(
          value: currentStatus,
          items: ['pending', 'sedang disiapkan', 'selesai']
              .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(
                      status[0].toUpperCase() + status.substring(1),
                      style: TextStyle(fontSize: 14),
                    ),
                  ))
              .toList(),
          onChanged: (newStatus) {
            if (newStatus != null) {
              FirebaseFirestore.instance
                  .collection('orders')
                  .doc(orderId)
                  .update({'status': newStatus});
              Navigator.of(ctx).pop();
            }
          },
        ),
      ),
    );
  }
}
