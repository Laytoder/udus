import 'package:flutter/material.dart';
import 'package:swipedetector/swipedetector.dart';

class DraggableStackList extends StatefulWidget {
  int itemCount;
  //double width, height;
  Widget Function(BuildContext context, int index) itemBuilder;
  DraggableStackList({this.itemCount, this.itemBuilder});
  @override
  _DraggableStackListState createState() => _DraggableStackListState();
}

class _DraggableStackListState extends State<DraggableStackList>
    with TickerProviderStateMixin {
  List<Widget> items = [];
  List<AnimationController> _dragControllers = [];
  //double _dragStartVal;
  //AnimationController _currentController;
  int _currentIndex;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.itemCount; i++) {
      var controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300));
      controller.value = 1.0;
      _dragControllers.add(controller);
    }
    _currentIndex = widget.itemCount - 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < widget.itemCount; i++) {
        _dragControllers[i]
          ..addListener(() {
            setState(() {});
          });
      }
    });
  }

  /*onDrag(BuildContext context, DragUpdateDetails details, int index) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(details.globalPosition);
    double value = (offset.dy) / widget.height;
    //drap up case
    if (value < _dragStartVal) {
      print('drag up');
      _dragControllers[index].value = value;
      _currentController = _dragControllers[index];
      _currentIndex = index;
    }
    //drag down case
    if (value > _dragStartVal) {
      print('drag down');
      _dragControllers[index + 1].value = value;
      _currentController = _dragControllers[index + 1];
    }
  }*/

  /*onDragStart(BuildContext context, DragStartDetails details) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(details.globalPosition);
    double value = (offset.dy) / widget.height;
    _dragStartVal = value;
    print(value);
  }

  onDragEnd() {
    if (_currentController.isAnimating) return;

    if (_currentController.value > 0.5) {
      _currentController.fling(velocity: 1.0);
    } else {
      _currentController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
    }
  }*/

  onSwipeUp(int index) {
    if(index == 0) return;
    AnimationController controller = _dragControllers[index];
    _currentIndex = index - 1;
    controller.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  onSwipeDown(int index) {
    if(index == widget.itemCount - 1) return;
    AnimationController controller =
        _dragControllers[index + 1];
    _currentIndex = index + 1;
    controller.fling(velocity: 1.0);
  }

  itemListBuilder(BuildContext context) {
    items = [];
    for (int i = 0; i < widget.itemCount; i++) {
      Widget item = Align(
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          /*heightFactor:
                1 - (_dragController.value * (0.4 + (0.09 + 0.008 / 2))),*/
          heightFactor: _dragControllers[i].value,
          //heightFactor: (0.5 + (0.05 / 8.5)),
          //heightFactor: 210 / 678,
          widthFactor: 1.0,
          child: SwipeDetector(
            //onVerticalDragEnd: (_) => onDragEnd(),
            //onVerticalDragStart: (details) => onDragStart(context, details),
            //onVerticalDragUpdate: (details) => onDrag(context, details, i),
            onSwipeUp: () {
              onSwipeUp(i);
            },
            onSwipeDown: () {
              onSwipeDown(i);
            },
            child: Container(
              child: widget.itemBuilder(context, i),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35.0),
                  bottomRight: Radius.circular(35.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      items.add(item);
    }
    List<Widget> cachedItems = [];
    if (_currentIndex > 0) cachedItems.add(items[_currentIndex - 1]);
    cachedItems.add(items[_currentIndex]);
    if (_currentIndex < (widget.itemCount - 1))
      cachedItems.add(items[_currentIndex + 1]);
    return cachedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: itemListBuilder(context),
    );
  }
}
