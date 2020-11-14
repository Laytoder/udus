import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/models/vegetable.dart';

class SearchItems extends SearchDelegate<Vegetable> {
  List<Vegetable> avlVegs;

  SearchItems({@required this.avlVegs});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Color(0xffE0E5EC),
      backgroundColor: Color(0xffE0E5EC),
    );
  }

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
    for (Vegetable vegetable in avlVegs) {
      if (vegetable.name.toLowerCase().contains(query)) {
        vegetable.dispCommonName = false;
        vegetable.currCommonName = '';
        results.add(vegetable);
      } else {
        List<String> commonNames = vegetable.commonNames;
        for (String commonName in commonNames) {
          if (commonName.toLowerCase().contains(query)) {
            vegetable.dispCommonName = true;
            vegetable.currCommonName = commonName;
            results.add(vegetable);
            break;
          }
        }
      }
    }
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Color(0xffE0E5EC),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Neumorphic(
              margin: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
              ),
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(15.0),
                ),
                depth: results[index].isSelected ? -3 : 3,
                lightSource: LightSource.topLeft,
                border: NeumorphicBorder(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: Color(0xffE0E5EC),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      results[index].imageUrl,
                    ),
                    radius: (25 / 678) * height,
                  ),
                  title: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        results[index].name +
                            (results[index].dispCommonName
                                ? '(${results[index].currCommonName})'
                                : ''),
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
                              results[index].quantity.toString() + ' kg',
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
                            results[index].isSelected
                                ? Icons.remove_circle
                                : Icons.add_box,
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
          );
        },
        itemCount: results.length,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Vegetable> suggestions = [];
    for (Vegetable vegetable in avlVegs) {
      if (vegetable.name.toLowerCase().contains(query)) {
        vegetable.dispCommonName = false;
        vegetable.currCommonName = '';
        suggestions.add(vegetable);
      } else {
        List<String> commonNames = vegetable.commonNames;
        for (String commonName in commonNames) {
          if (commonName.toLowerCase().contains(query)) {
            vegetable.dispCommonName = true;
            vegetable.currCommonName = commonName;
            suggestions.add(vegetable);
            break;
          }
        }
      }
    }
    double height = MediaQuery.of(context).size.height;
    //if (query == '') suggestions = suggestions.take(5);
    return Container(
      color: Color(0xffE0E5EC),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Neumorphic(
              margin: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 10.0,
              ),
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(15.0),
                ),
                depth: suggestions[index].isSelected ? -3 : 3,
                lightSource: LightSource.topLeft,
                border: NeumorphicBorder(
                  color: Colors.white,
                  width: 0.5,
                ),
                color: Color(0xffE0E5EC),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      suggestions[index].imageUrl,
                    ),
                    radius: (25 / 678) * height,
                  ),
                  title: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      Text(
                        suggestions[index].name +
                            (suggestions[index].dispCommonName
                                ? '(${suggestions[index].currCommonName})'
                                : ''),
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
                              suggestions[index].quantity.toString() + ' kg',
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
                            suggestions[index].isSelected
                                ? Icons.remove_circle
                                : Icons.add_box,
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
          );
        },
        itemCount: suggestions.length,
      ),
    );
  }
}
