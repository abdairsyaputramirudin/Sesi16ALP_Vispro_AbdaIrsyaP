import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, String name, double price) {
    print("addItem called with productId: $productId");
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          name: name,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
    print("Current items in cart: $_items");
  }

  void updateItemQuantity(String productId, int change) {
    print(
        "updateItemQuantity called with productId: $productId, change: $change");
    if (_items.containsKey(productId)) {
      final updatedQuantity = _items[productId]!.quantity + change;

      if (updatedQuantity > 0) {
        _items.update(
          productId,
          (existingItem) => CartItem(
            id: existingItem.id,
            name: existingItem.name,
            quantity: updatedQuantity,
            price: existingItem.price,
          ),
        );
      } else {
        _items.remove(productId);
        print("Item with productId: $productId removed as quantity reached 0");
      }
      notifyListeners();
    }
    print("Current items in cart: $_items");
  }

  void removeItem(String productId) {
    print("removeItem called with productId: $productId");
    if (_items.containsKey(productId)) {
      _items.remove(productId);
      notifyListeners();
    }
    print("Current items in cart after removal: $_items");
  }

  void clear() {
    _items.clear();
    notifyListeners();
    print("Cart cleared. Current items: $_items");
  }
}
