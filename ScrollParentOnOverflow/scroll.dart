import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return ScrollParentOnOverflow(
            child: AspectRatio(
              aspectRatio: 1.9,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 12.0,
                ),
                child: ColoredBox(
                  color: Colors.grey.shade200,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        for (int i = 0; i < 10; i++) //
                          ElevatedButton(
                            onPressed: () {
                              print('pressed button $index/$i');
                            },
                            child: Text('Button $index/$i'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
    // return Material(
    //   child: CustomScrollView(
    //     slivers: [
    //       for (int index = 0; index < 20; index++) //
    //         SliverList(
    //           delegate: SliverChildBuilderDelegate(
    //             childCount: 10,
    //             (BuildContext context, int i) {
    //               return Center(
    //                 child: ElevatedButton(
    //                   onPressed: () {
    //                     print('pressed button $index/$i');
    //                   },
    //                   child: Text('Button $index/$i'),
    //                 ),
    //               );
    //             },
    //           ),
    //         ),
    //     ],
    //   ),
    // );
  }
}

class ScrollParentOnOverflow extends StatefulWidget {
  const ScrollParentOnOverflow({
    super.key,
    this.overscroll = false,
    required this.child,
  });

  final bool overscroll;
  final Widget child;

  @override
  State<ScrollParentOnOverflow> createState() =>
      _ScrollParentOnOverflowState();
}

class _ScrollParentOnOverflowState extends State<ScrollParentOnOverflow> {
  DragStartDetails? _startDetails;
  Drag? _drag;

  void dragCancelCallback() {
    _startDetails = null;
    _drag = null;
  }

  bool _onScrollNotification(ScrollNotification notification) {
    switch (notification) {
      case ScrollStartNotification(:final DragStartDetails dragDetails):
        _startDetails = dragDetails;
        return false;
      case OverscrollNotification(:final DragUpdateDetails dragDetails):
        if (_drag case Drag drag) {
          drag.update(dragDetails);
          return true;
        }
        if (_startDetails != null) {
          final pos = Scrollable.of(context).position;
          final drag = pos.drag(_startDetails!, dragCancelCallback);
          drag.update(dragDetails);
          _drag = drag;
          return true;
        }
      case ScrollEndNotification(:final dragDetails):
        if (_drag != null) {
          if (dragDetails != null) {
            _drag!.end(dragDetails);
          } else {
            _drag!.cancel();
          }
          _drag = null;
          _startDetails = null;
          return true;
        }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context) //
            .copyWith(overscroll: widget.overscroll),
        child: widget.child,
      ),
    );
  }
}
