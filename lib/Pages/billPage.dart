import 'package:flutter/material.dart';
import 'package:frute/AppState.dart';
import 'package:frute/Pages/homePage.dart';
import 'package:frute/helpers/tripCompleter.dart';
import 'package:frute/models/vegetable.dart';

class BillPage extends StatefulWidget {
  List<Vegetable> vegetables;
  double total;
  String vendorId;
  AppState appState;
  BillPage(this.vegetables, this.total, this.vendorId, this.appState);
  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  TripCompleter tripCompleter = TripCompleter();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify bill'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              setState(() => loading = true);
              await tripCompleter.completeTrip(
                  widget.vegetables, widget.total, widget.vendorId);
              setState(() => loading = false);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(widget.appState)),
              );
            },
          ),
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 20,
                  child: ListView.builder(
                    itemCount: widget.vegetables.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.fastfood),
                        ),
                        title: Wrap(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Text(widget.vegetables[index].name),
                          ],
                        ),
                        subtitle: Text(
                            widget.vegetables[index].quantity.toString() +
                                '/kg'),
                        trailing: Wrap(
                          children: <Widget>[
                            Text('\u20B9' +
                                widget.vegetables[index].price.toString()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: ListTile(
                    title: Text('Total: '),
                    trailing: Text(widget.total.toString()),
                  ),
                ),
              ],
            ),
    );
  }
}
