import 'cart_item.dart';

class Order {
  final String id;
  final String tableId;
  final List<CartItem> items;
  final double totalPrice;
  final String status;
  final String note;

  Order({
    required this.id,
    required this.tableId,
    required this.items,
    required this.totalPrice,
    this.status = 'pending',
    required this.note,
  });
}
