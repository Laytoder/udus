import 'package:flutter/material.dart';
import 'package:frute/utils/searcher.dart';

class SearchPage extends StatelessWidget {
  final avlVegs;

  const SearchPage({Key key, this.avlVegs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
              decoration: BoxDecoration(color: Colors.white),
              width: MediaQuery.of(context).size.width,
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
      ),
    );
  }
}
