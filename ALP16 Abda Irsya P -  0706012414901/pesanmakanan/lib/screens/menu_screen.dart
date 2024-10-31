import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class MenuScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 'nasi_goreng',
      'name': 'Nasi Goreng',
      'price': 25000.0,
      'description': 'Nasi goreng spesial dengan ayam dan telur.',
      'image':
          'https://www.themealdb.com/images/media/meals/wtsvxx1511296896.jpg'
    },
    {
      'id': 'mie_goreng',
      'name': 'Mie Goreng',
      'price': 20000.0,
      'description': 'Mie goreng lezat dengan bumbu khas.',
      'image':
          'https://www.themealdb.com/images/media/meals/xxyupu1468262513.jpg'
    },
    {
      'id': 'sate_ayam',
      'name': 'Sate Ayam',
      'price': 30000.0,
      'description': 'Sate ayam empuk dengan saus kacang.',
      'image':
          'https://www.themealdb.com/images/media/meals/xxpqsy1511452222.jpg'
    },
    {
      'id': 'soto_ayam',
      'name': 'Soto Ayam',
      'price': 28000.0,
      'description': 'Soto ayam segar dengan kuah kaldu ayam.',
      'image':
          'https://www.themealdb.com/images/media/meals/wtsvxx1511296896.jpg'
    },
    {
      'id': 'bakso',
      'name': 'Bakso',
      'price': 15000.0,
      'description': 'Bakso daging sapi dengan mie dan sayuran.',
      'image':
          'https://www.themealdb.com/images/media/meals/wtsvxx1511296896.jpg'
    },
    {
      'id': 'es_teh',
      'name': 'Es Teh Manis',
      'price': 5000.0,
      'description': 'Minuman segar es teh manis.',
      'image':
          'https://www.themealdb.com/images/media/meals/wqurxy1511453156.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final tableId = args['tableId'].toString();
    final customerName = args['customerName'];
    final phoneNumber = args['phoneNumber'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text("Menu - Meja $tableId"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    tableId: tableId,
                    customerName: customerName,
                    phoneNumber: phoneNumber,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return GestureDetector(
            onTap: () {
              _showItemDetails(context, item);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Rp ${item['price']},-",
                          style:
                              TextStyle(color: Colors.green[700], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        item['id'],
                        item['name'],
                        item['price'],
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${item['name']} ditambahkan ke keranjang!"),
                      ));
                    },
                    child: Text("Tambah ke Keranjang",
                        style: TextStyle(color: Colors.green[600])),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title:
            Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
            ),
            SizedBox(height: 10),
            Text(item['description'], style: TextStyle(fontSize: 14)),
            SizedBox(height: 10),
            Text(
              "Rp ${item['price']},-",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Tutup"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600]),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).addItem(
                item['id'],
                item['name'],
                item['price'],
              );
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${item['name']} ditambahkan ke keranjang!"),
              ));
            },
            child: Text("Tambah ke Keranjang"),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Konfirmasi Logout"),
        content: Text("Apakah Anda yakin ingin mengakhiri sesi?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
