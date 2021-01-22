import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_section_list/custom_sliver.dart';

import 'lsit_contarin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  ScrollController _scrollController = ScrollController();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Builder(
          builder: (ctx) {
            return NotificationListener(
              onNotification: (ScrollNotification noti) {
                return false;
              },
              child: CustomScrollView(
                  controller: widget._scrollController,
                  slivers: buildSlivers(ctx)),
            );
          },
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  List<Widget> buildSlivers(BuildContext ctx) {
    List<Widget> slivers = [];
    for (int section = 0; section < 10; section++) {
      ValueNotifier floating = ValueNotifier<bool>(false);
      ValueNotifier scrollex = ValueNotifier<listScrollEx>(listScrollEx(0.0));
      CustomSliverWidget sliverHeader = CustomSliverWidget(
          floating: floating,
          scrollex: scrollex,
          child: Container(
            height: 66,
            child: Align(
                alignment: Alignment(0.9, 0),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print('header: $section');
                    SnackBar bar = SnackBar(
                      content: Text('查看更多第$section 组'),
                    );
                    Scaffold.of(ctx).removeCurrentSnackBar();
                    Scaffold.of(ctx).showSnackBar(bar);
                  },
                  child: Text('查看更多: $section >'),
                )),
            color: Colors.red,
          ));
      ListContarin list =
          ListContarin(widget._scrollController, floating, scrollex);
      slivers.add(sliverHeader);
      slivers.add(list);
    }

    return slivers;
  }
}
