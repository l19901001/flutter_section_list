import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListContarin extends StatelessWidget {
  ListContarin(this.controller, this.floating, this.scrollex, {Key key})
      : super(key: key);
  final ScrollController controller;
  final ValueNotifier<bool> floating;
  final ValueNotifier<listScrollEx> scrollex;

  void _init(BuildContext context) {
    controller.addListener(() {
      RenderSliverList sliverList = context.findRenderObject();
      // SliverPhysicalContainerParentData parent = sliverList.parentData;
      SliverGeometry geometry = sliverList.geometry;
      // SliverConstraints constraints = sliverList.constraints;
      // double offset = constraints.scrollOffset;
      listScrollEx scr = scrollex.value;
      if (scr.scrollExtent != geometry.scrollExtent && geometry.visible) {
        scrollex.value = listScrollEx(geometry.scrollExtent);
      }
      // if (parent.paintOffset.dy == 0 && offset >= geometry.scrollExtent - 66) {
      //   if (!floating.value) floating.value = true;
      //   print('addListener--floating == true');
      // } else if (floating.value) {
      //   floating.value = false;
      //   print('addListener--floating == false');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _init(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (ctx, index) => GestureDetector(
                child: Container(
                  child: Text('Container $index'),
                  height: index % 2 == 0 ? 44 : 188,
                  width: double.infinity,
                  color: Colors.orange,
                ),
                onTap: () {
                  print('SliverChildBuilderDelegate == $index');
                },
              ),
          childCount: 3),
    );
  }
}

// ignore: camel_case_types
class listScrollEx {
  listScrollEx(this.scrollExtent);
  final scrollExtent;
}
