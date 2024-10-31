import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  final double totalPrice;
  final String customerName;
  final String tableId;
  final List<Map<String, dynamic>> items;
  final String note;

  InvoiceScreen({
    required this.totalPrice,
    required this.customerName,
    required this.tableId,
    required this.items,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text("Invoice", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Struk Pembayaran",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              margin: EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama Pelanggan: $customerName",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Text("Nomor Meja: $tableId",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 5),
                    Text("Total Harga: Rp $totalPrice",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("Catatan: $note", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            Text(
              "Daftar Pesanan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  var item = items[i];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(
                        item['name'] ?? 'Unknown Item',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text("Jumlah: ${item['quantity'] ?? '0'}"),
                      trailing: Text(
                        "Rp ${item['price'] ?? '0'}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(thickness: 1.5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Rp $totalPrice",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
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
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/menu'));
              },
              child: Text(
                "Selesai",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
