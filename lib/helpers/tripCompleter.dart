import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frute/models/vegetable.dart';

class TripCompleter {
  final firestoreInstance = Firestore.instance;

  completeTrip(
      List<Vegetable> purchasedVegetables, double total, String vendorId) async {
    final postRef =
        firestoreInstance.collection('vendor_live_data').document(vendorId);

    await firestoreInstance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      print(postRef.toString());
      print(postSnapshot.toString());
      if (postSnapshot.exists) {
        print('post exists');
        Map<String, dynamic> data = postSnapshot.data;
        List<dynamic> njsonVegetables = data['normalVegetables'];
        List<dynamic> sjsonVegetables = data['specialVegetables'];
        List<Vegetable> currentNVegs = [], currentSVegs = [];
        for (dynamic jsonVeg in njsonVegetables) {
          currentNVegs.add(Vegetable.fromJson(jsonVeg));
        }
        for (dynamic jsonVeg in sjsonVegetables) {
          currentSVegs.add(Vegetable.fromJson(jsonVeg));
        }
        for (Vegetable veg1 in currentNVegs) {
          for (Vegetable veg2 in purchasedVegetables) {
            if (veg1.name == veg2.name)
              veg1.quantity = veg1.quantity - veg2.quantity;
          }
        }
        for (Vegetable veg1 in currentSVegs) {
          for (Vegetable veg2 in purchasedVegetables) {
            if (veg1.name == veg2.name)
              veg1.quantity = veg1.quantity - veg2.quantity;
          }
        }
        List<dynamic> updatedNVegJson = [];
        for (Vegetable updatedVeg in currentNVegs) {
          updatedNVegJson.add(updatedVeg.toJson());
        }
        List<dynamic> updatedSVegJson = [];
        for (Vegetable updatedVeg in currentSVegs) {
          updatedSVegJson.add(updatedVeg.toJson());
        }
        int pendingTrips = data['pendingTrips'];
        pendingTrips = pendingTrips - 1;
        double turnover = 0;
        if(data.containsKey('turnover')) turnover = data['turnover'];
        turnover = turnover + total;
        int completedTrips = 0;
        if(data.containsKey('trips')) completedTrips = data['trips'];
        completedTrips = completedTrips + 1;

        print('reached to the point of updating in transaction');
        await tx.update(postRef, <String, dynamic> {
          'normalVegetables': updatedNVegJson,
          'specialVegetables': updatedSVegJson,
          'turnover': turnover,
          'pendingTrips': pendingTrips,
          'completedTrips': completedTrips,
          'active': true
        });
      }
    });
  }
}
