import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/billPage.dart';
import 'package:frute/Pages/vendorInfoPage.dart';
import 'package:frute/helpers/messageGetters.dart';
import 'package:frute/models/bill.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/vendorInfo.dart';

class PriceListPage extends StatelessWidget {
  VendorInfo vendor;
  AppState appState;

  PriceListPage(this.vendor, this.appState);

  waitForReplyAndLaunch(BuildContext context) async {
    appState.messages = StreamController();
    var messageMap = await getReply(appState);
    List<dynamic> jsonVegetables = messageMap['purchasedVegetables'];
    List<Vegetable> purchasedVegetables = [];
    for (dynamic jsonVegetable in jsonVegetables) {
      Vegetable vegetable = Vegetable.fromJson(jsonVegetable);
      purchasedVegetables.add(vegetable);
    }
    double total = messageMap['total'];
    appState.pendingTrip.state = 'verification';
    appState.pendingTrip.verificationBill =
        Bill(purchasedVegetables, total, DateTime.now());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BillPage(
          state: 'Verification',
          vegetables: purchasedVegetables,
          total: total,
          appState: appState,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    waitForReplyAndLaunch(context);
    return Scaffold(
      body: VendorInfoPage(vendor, appState),
    );
  }
}
