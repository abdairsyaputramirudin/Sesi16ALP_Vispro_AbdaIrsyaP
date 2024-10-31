import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();

  Future<void> confirmAndAddOrder({
    required String tableId,
    required List<CartItem> items,
    required double totalPrice,
    required String customerName,
    required String phoneNumber,
    required String note,
  }) async {
    List<Map<String, dynamic>> mappedItems =
        items.map((item) => item.toMap()).toList();

    print("Memproses dan menyimpan pesanan setelah konfirmasi pembayaran.");
    print("Table ID: $tableId");
    print("Total Price: $totalPrice");
    print("Customer Name: $customerName");
    print("Phone Number: $phoneNumber");
    print("Note: $note");
    print("Items: $mappedItems");

    await _orderService.createOrder(
      tableId,
      totalPrice,
      mappedItems,
      customerName,
      phoneNumber,
      note,
    );

    notifyListeners();
  }
}
