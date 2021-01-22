import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'lsit_contarin.dart';

class CustomSliverWidget extends SingleChildRenderObjectWidget {
  CustomSliverWidget({key, Widget child, this.floating, this.scrollex})
      : super(key: key, child: child);

  final ValueNotifier floating;
  final ValueNotifier<listScrollEx> scrollex;

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderCustomSliverWidget(floating, scrollex);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderCustomSliverWidget renderObject) {
    // TODO: implement updateRenderObject
    renderObject..floating = floating;
  }
}

class RenderCustomSliverWidget extends RenderSliverSingleBoxAdapter {
  RenderCustomSliverWidget(
      ValueNotifier floating, ValueNotifier<listScrollEx> scrollex)
      : this.floating = floating,
        this.scrollex = scrollex,
        super();
  ValueNotifier floating;
  ValueNotifier<listScrollEx> scrollex;
  double floatPostion = double.infinity;

  double get childExtent =>
      constraints.axis == Axis.vertical ? child.size.height : child.size.width;

  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    // TODO: implement layout
    // print('layout  size = ${child.size}');
    // super.layout(constraints, parentUsesSize: parentUsesSize);
    SliverConstraints cons = constraints;
    cons = cons.copyWith(remainingPaintExtent: cons.scrollOffset + 66);
    super.layout(cons, parentUsesSize: parentUsesSize);
  }

  @override
  bool hitTestBoxChild(BoxHitTestResult result, RenderBox child,
      {double mainAxisPosition, double crossAxisPosition}) {
    // TODO: implement hitTestBoxChild
    bool res = super.hitTestBoxChild(result, child,
        mainAxisPosition: mainAxisPosition + constraints.scrollOffset,
        crossAxisPosition: crossAxisPosition);
    return res;
  }

  @override
  bool hitTest(SliverHitTestResult result,
      {double mainAxisPosition, double crossAxisPosition}) {
    // TODO: implement hitTest
    bool res = super.hitTest(result,
        mainAxisPosition: mainAxisPosition + constraints.scrollOffset,
        crossAxisPosition: crossAxisPosition);
    return res;
  }

  // RenderSemanticsGestureHandler findGesture(RenderObject objc) {
  //   objc.visitChildren((renderObc) {
  //     if (renderObc is RenderSemanticsGestureHandler) {
  //       RenderSemanticsGestureHandler handle = renderObc;
  //       print('visitChildren == $renderObc');
  //       if (handle.onTap != null && event.original is PointerUpEvent) {
  //         handle.onTap();
  //       } else {
  //         super.handleEvent(event, entry);
  //       }
  //       return renderObc;
  //     } else if (renderObc != null) {
  //       findGesture(renderObc);
  //     }
  //   });
  //   return null;
  // }

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    void findGesture(RenderObject objc) {
      objc.visitChildren((renderObc) {
        if (renderObc is RenderSemanticsGestureHandler) {
          RenderSemanticsGestureHandler handle = renderObc;
          if (handle.onTap != null && event.original is PointerUpEvent) {
            handle.onTap();
          } else {
            super.handleEvent(event, entry);
          }
        } else if (renderObc != null) {
          findGesture(renderObc);
        }
      });
    }

    findGesture(child);
  }

  @override
  bool hitTestSelf({double mainAxisPosition, double crossAxisPosition}) {
    return true;
  }

  // @override
  // double childMainAxisPosition(covariant RenderBox child) =>
  //     constraints.scrollOffset;

  // @override
  // bool hitTestChildren(SliverHitTestResult result,
  //     {double mainAxisPosition, double crossAxisPosition}) {
  //   // TODO: implement hitTestChildren
  //   bool res = super.hitTestChildren(result,
  //       mainAxisPosition: constraints.scrollOffset + mainAxisPosition,
  //       crossAxisPosition: crossAxisPosition);
  //   return res;
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    // print('offset == $offset');
    super.paint(context, offset);
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    // print('constraints.overlap == ${constraints.overlap}');
    // TODO: implement performLayout
    // 将 SliverConstraints 转化为 BoxConstraints 对 child 进行 layout
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    // 计算绘制大小
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    // 计算缓存大小
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);
    // print(
    //     'paintedChildSize == $paintedChildSize, cacheExtent = $cacheExtent, childExtent = $childExtent');

    if (floating != null && floating.value) {
      if (floatPostion == double.infinity) {
        floatPostion = constraints.scrollOffset;
      }
      // print('floating == ${floating.value},  floatPostion == $floatPostion');
    } else {
      floatPostion = double.infinity;
      if (floating != null) {
        // print('floating == ${floating.value},  floatPostion == $floatPostion');
      }
    }
    // 输出 SliverGeometry
    listScrollEx src = scrollex.value;
    double paintOrigin = constraints.scrollOffset;
    if (src != null) {
      paintOrigin = (constraints.scrollOffset < src.scrollExtent
          ? constraints.scrollOffset
          : src.scrollExtent);
    }
    // paintOrigin =
    //     constraints.scrollOffset < 1980 ? constraints.scrollOffset : 1980;
    // print('addListener scrollExtent = ${src.scrollExtent}, $paintOrigin');
    bool hasVisualOverflow = childExtent > constraints.remainingPaintExtent ||
        constraints.scrollOffset > 0.0;
    bool visible = constraints.scrollOffset < floatPostion + childExtent;

    // print('hasVisualOverflow == $visible');

    geometry = SliverGeometry(
        scrollExtent: childExtent,
        paintExtent: childExtent,
        cacheExtent: cacheExtent,
        maxPaintExtent: childExtent,
        paintOrigin: paintOrigin,
        layoutExtent: paintedChildSize,
        visible: visible,
        hitTestExtent: childExtent,
        hasVisualOverflow: hasVisualOverflow);

    setChildParentData(child, constraints, geometry);
  }
}

class CustomBoxWidget extends SingleChildRenderObjectWidget {
  CustomBoxWidget({key, Widget child}) : super(key: key, child: child);
  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return RenderCustomBox();
  }
}

class RenderCustomBox extends RenderBox with RenderObjectWithChildMixin {
  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    // TODO: implement layout
    super.layout(constraints, parentUsesSize: parentUsesSize);
  }

  //必须使用，作用是初始化data对象
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! PageParentData)
      child.parentData = PageParentData();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // TODO: implement paint
    super.paint(context, offset);
  }

  // @override
  // TODO: implement sizedByParent
  // bool get sizedByParent => true;

  @override
  void performLayout() {
    // TODO: implement performLayout
    // child.layout(constraints, parentUsesSize: true);
    size = constraints
        .tighten(
          height: 66,
          width: constraints.constrainWidth(),
        )
        .smallest;
  }

  // @override
  // void paint(PaintingContext context, Offset offset) {
  //   context.paintChild(child, offset);
  // }
}

class PageParentData extends ContainerBoxParentData<RenderBox> {}
