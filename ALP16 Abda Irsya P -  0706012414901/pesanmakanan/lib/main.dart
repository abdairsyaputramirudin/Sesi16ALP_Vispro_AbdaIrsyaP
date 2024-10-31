import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/customer_info_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/invoice_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_screen.dart';

import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Aplikasi Pemesanan Makanan',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/customer-info': (context) => CustomerInfoScreen(),
          '/menu': (context) => MenuScreen(),
          '/admin-login': (context) => AdminLoginScreen(),
          '/admin': (context) => AdminScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/cart') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => CartScreen(
                tableId: args['tableId'],
                customerName: args['customerName'],
                phoneNumber: args['phoneNumber'],
              ),
            );
          }
          if (settings.name == '/checkout') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => CheckoutScreen(
                tableId: args['tableId'],
                customerName: args['customerName'],
                phoneNumber: args['phoneNumber'],
              ),
            );
          }
          if (settings.name == '/payment') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => PaymentScreen(
                totalAmount: args['totalAmount'],
                orderProvider: args['orderProvider'],
                items: args['items'],
                tableId: args['tableId'],
                customerName: args['customerName'],
                phoneNumber: args['phoneNumber'],
                note: args['note'],
              ),
            );
          }
          if (settings.name == '/invoice') {
            final invoiceData = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => InvoiceScreen(
                totalPrice: invoiceData['totalPrice'],
                customerName: invoiceData['customerName'],
                tableId: invoiceData['tableId'],
                items: List<Map<String, dynamic>>.from(invoiceData['items']),
                note: invoiceData['note'],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
