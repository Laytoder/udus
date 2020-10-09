import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frute/models/order.dart';
import 'package:frute/models/vendorInfo.dart';

class VendorServiceHelper {
  final firestoreInstance = Firestore.instance;

  Future createNewOrder(Order order, String vendorId) async {
    CollectionReference collection = firestoreInstance
        .collection('vendor_live_data')
        .document(vendorId)
        .collection('orders');
    
    print(order.toFireJson());
    DocumentReference doc = await collection.add(order.toFireJson());
    order.id = doc.documentID;
  }
}
