import 'package:cloud_firestore/cloud_firestore.dart';

class TableService {
  final CollectionReference _tableCollection =
      FirebaseFirestore.instance.collection('tables');

  Future<bool> isTableAvailable(String tableId) async {
    try {
      DocumentSnapshot snapshot = await _tableCollection.doc(tableId).get();
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        return data['status'] == 'available';
      } else {
        return true;
      }
    } catch (e) {
      print("Error checking table availability: $e");
      return false;
    }
  }

  Future<void> updateTableStatus(String tableId, String status) async {
    try {
      await _tableCollection.doc(tableId).set({
        'status': status,
        'updatedAt': Timestamp.now(),
      }, SetOptions(merge: true));
    } catch (e) {
      print("Error updating table status: $e");
    }
  }

  Future<void> resetAllTables() async {
    try {
      var snapshot = await _tableCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.update({'status': 'available'});
      }
    } catch (e) {
      print("Error resetting tables: $e");
    }
  }
}
