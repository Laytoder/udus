import 'package:flutter/material.dart';
import 'dualSlideButton.dart';
import 'vendorSelectionPanel.dart';
import 'package:mapbox_search_flutter/mapbox_search_flutter.dart' as map;
import 'package:infinite_listview/infinite_listview.dart';
import 'draggableStackList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //scaffoldBackgroundColor: Color(0xffff8d27),
        scaffoldBackgroundColor: Color(0xffffb300),
        primaryColor: Colors.white,
        accentColor: Color(0xffffb300),
        canvasColor: Colors.transparent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _upperPanelController;
  String placeName = '22-1b baker street, London';
  List<int> testNums = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; i++) testNums.add(i + 1);
    _upperPanelController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _upperPanelController.value = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _upperPanelController
        ..addListener(() {
          setState(() {});
        });
    });
  }

  _showModelLocationSearch() {
    //String placeglobal = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext innercontext) {
        return Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 5,
              left: 15.0,
              right: 15.0),
          height: MediaQuery.of(context).size.height / 1,
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: map.MapBoxPlaceSearchWidget(
              popOnSelect: true,
              apiKey:
                  "pk.eyJ1IjoibGF5dG9kZXIiLCJhIjoiY2s1aWFvZ3p4MGJrdjNtcGExdmloajdxcCJ9.QDtsmdqwqUUgjKSzlsw8RA",
              //limit: 10,
              //height: 10,
              searchHint: 'Search',
              onSelected: (place) {
                //placeglobal = place.placeName;]
                //Navigator.of(context).pop(place.placeName);
                placeName = place.placeName;
              },
              context: innercontext,
            ),
          ),
        );
        /*return Align(
          heightFactor: 1,
          alignment: Alignment.topCenter,
          child: map.MapBoxPlaceSearchWidget(
            popOnSelect: true,
            apiKey:
                "pk.eyJ1IjoibGF5dG9kZXIiLCJhIjoiY2s1aWFvZ3p4MGJrdjNtcGExdmloajdxcCJ9.QDtsmdqwqUUgjKSzlsw8RA",
            limit: 10,
            //height: 10,
            searchHint: 'Search',
            onSelected: (place) {},
            context: innercontext,
          ),
        );*/
      },
    );
    //return placeglobal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Icon(Icons.shopping_cart),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: null,
          )
        ],
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: _upperPanelController.value,
            child: InfiniteListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://media.istockphoto.com/photos/tomato-isolated-on-white-background-picture-id466175630?k=6&m=466175630&s=612x612&w=0&h=fu_mQBjGJZIliOWwCR0Vf2myRvKWyQDsymxEIi8tZ38='),
                  ),
                  title: Text('Tomato'),
                  subtitle: Text('Available Quantity: 10 grams'),
                  trailing: Text('\u20B9 10/kg'),
                );
              },
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 25,
                child: Container(),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: DualSlideButton(
                        width: MediaQuery.of(context).size.width - 40,
                        onDrag: (value) {
                          value = value;
                          _upperPanelController.value = value;
                        },
                        onDragEnd: () {
                          if (_upperPanelController.isAnimating) return;

                          if (_upperPanelController.value > 0.5) {
                            _upperPanelController.fling(velocity: 1.0);
                          } else {
                            _upperPanelController.animateTo(0.0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear);
                          }
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(),
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              /*Expanded(
                flex: 20,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: FractionallySizedBox(
                    heightFactor: 1 -
                        (_upperPanelController.value *
                            (0.4 + (0.09 + 0.008 / 2))),
                    //heightFactor: (0.5 + (0.05 / 8.5)),
                    //heightFactor: 210 / 678,
                    widthFactor: 1.0,
                    child: Container(
                      child: VendorSelectionPanel(
                        showModalSearchLocation: _showModelLocationSearch,
                        placeName: placeName,
                        upperFadeVal: 1 - _upperPanelController.value,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35.0),
                          bottomRight: Radius.circular(35.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
              Expanded(
                flex: 20,
                child: DraggableStackList(
                  itemCount: testNums.length,
                  itemBuilder: (context, index) {
                    return VendorSelectionPanel(
                      showModalSearchLocation: _showModelLocationSearch,
                      placeName: placeName,
                      upperFadeVal: 1 - _upperPanelController.value,
                    );
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
