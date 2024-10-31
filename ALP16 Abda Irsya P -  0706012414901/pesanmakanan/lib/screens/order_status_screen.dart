import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderStatusScreen extends StatelessWidget {
  final String orderId;

  OrderStatusScreen({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text(
          "Status Pesanan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Pesanan tidak ditemukan."));
          }

          var orderData = snapshot.data!.data() as Map<String, dynamic>;
          var items = orderData['items'] as List;
          var status = orderData['status'] ?? 'pending';

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status Pesanan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
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
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      status[0].toUpperCase() + status.substring(1),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(thickness: 1.5),
                SizedBox(height: 10),
                Text(
                  "Detail Pesanan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, i) {
                      var item = items[i];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          title: Text(
                            item['name'] ?? 'Item Tidak Dikenal',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text("Jumlah: ${item['quantity']}"),
                          trailing: Text(
                            "Rp ${item['price']}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
