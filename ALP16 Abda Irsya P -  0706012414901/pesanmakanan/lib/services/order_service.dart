import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<void> createOrder(String tableId, double totalPrice, List<Map<String, dynamic>> items,
    String customerName, String phoneNumber, String note) async {
  try {
    print("Saving to Firestore:");
    print("Table ID: $tableId");
    print("Total Price: $totalPrice");
    print("Customer Name: $customerName");
    print("Phone Number: $phoneNumber");
    print("Note: $note");
    print("Items: $items");

    await _orderCollection.add({
      'tableId': tableId,
      'status': 'pending',
      'totalPrice': totalPrice,
      'items': items,
      'createdAt': Timestamp.now(),
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'note': note,
    });
  } catch (e) {
    print("Error creating order: $e");
  }
}

}
