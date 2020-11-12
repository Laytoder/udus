import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frute/models/vegetable.dart';
import 'package:frute/utils/searcher.dart';

class PanelGridView extends StatelessWidget {
  String title;
  List<Vegetable> vegetables;

  PanelGridView({
    @required this.title,
    @required this.vegetables,
  });

  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffE0E5EC),
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        backgroundColor: Color(0xffE0E5EC),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await showSearch(
                context: context,
                delegate: SearchItems(),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          vegetables.length,
          (index) => Container(
            margin: EdgeInsets.only(
              top: (10 / 640) * height,
              //bottom: (10 / 640) * height,
              left: (10 / 360) * width,
              right: (10 / 360) * width,
            ),
            //width: (100 / 360) * width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: InkWell(
                    onTap: () {},
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        depth: 3,
                        lightSource: LightSource.top,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Color(0xffE0E5EC),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                            )
                          ],
                        ),
                        //height: (87 / 678) * height,
                        //width: (87 / 678) * height,
                        child: Image.asset(
                          vegetables[index].imageUrl,
                          //width: (100 / 360) * width,
                          //height: (100 / 640) * height,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: (6 / 678) * height,
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      vegetables[index].name,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontSize: (12 / (640 * 360)) * height * width,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
