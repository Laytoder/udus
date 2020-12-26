import 'package:flutter/material.dart';
import 'package:frute/utils/searcher.dart';
import 'package:frute/widgets/MinimalPageHeading.dart';

class SearchPage extends StatelessWidget {
  final avlVegs;

  const SearchPage({Key key, this.avlVegs}) : super(key: key);

  Widget searchBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: () async {
          await showSearch(
            context: context,
            delegate: SearchItems(
              avlVegs: avlVegs,
            ),
          );
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.search),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("Search for fruits and vegetables"),
                )
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [MinimalPageHeading(heading: "Search"), searchBox(context)],
        ),
      ),
    );
  }
}

// TODO: create a suggestion panel
