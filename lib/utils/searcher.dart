import 'package:flutter/material.dart';
import 'package:frute/Animations/FadeAnimations.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/models/normalVegetableList.dart';

class SearchItems extends SearchDelegate<Vegetable> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back), onPressed: () => close(context, null));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Vegetable> results = [];
    for (Vegetable vegetable in vegetables) {
      if (vegetable.name.toLowerCase().contains(query)) results.add(vegetable);
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        return FadeAnimation(
          0.5,
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color:
                  results[index].isSelected ? Colors.amberAccent : Colors.white,
              shadowColor: Color.fromRGBO(35, 205, 99, 0.2),
              elevation: 5.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 52,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: results[index].isSelected
                              ? BorderRadius.circular(15.0)
                              : BorderRadius.circular(0.0),
                          border: Border.all(
                            color: results[index].isSelected
                                ? Colors.green
                                : Colors.transparent,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              results[index].imageUrl,
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        results[index].name,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.normal,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    children: <Widget>[
                      results[index].isSelected
                          ? Text(
                              '\u20B9' +
                                  results[index].price.toString() +
                                  '/kg',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                              child: Container(),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: GestureDetector(
                          child: Icon(
                            Icons.add_box,
                            color: results[index].isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black26,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: results.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Vegetable> suggestions = [];
    for (Vegetable vegetable in vegetables) {
      if (vegetable.name.toLowerCase().contains(query))
        suggestions.add(vegetable);
    }
    //if (query == '') suggestions = suggestions.take(5);
    return ListView.builder(
      itemBuilder: (context, index) {
        return FadeAnimation(
          0.5,
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: suggestions[index].isSelected
                  ? Colors.amberAccent
                  : Colors.white,
              shadowColor: Color.fromRGBO(35, 205, 99, 0.2),
              elevation: 5.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 52,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: suggestions[index].isSelected
                              ? BorderRadius.circular(15.0)
                              : BorderRadius.circular(0.0),
                          border: Border.all(
                            color: suggestions[index].isSelected
                                ? Colors.green
                                : Colors.transparent,
                            width: 0.5,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              suggestions[index].imageUrl,
                            ),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        suggestions[index].name,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.normal,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    children: <Widget>[
                      suggestions[index].isSelected
                          ? Text(
                              '\u20B9' +
                                  suggestions[index].price.toString() +
                                  '/kg',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                              child: Container(),
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: GestureDetector(
                          child: Icon(
                            Icons.add_box,
                            color: suggestions[index].isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black26,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      itemCount: suggestions.length,
    );
  }
}
