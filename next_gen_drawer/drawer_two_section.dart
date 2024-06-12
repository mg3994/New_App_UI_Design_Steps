import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SingleChildScrollViewExample(),
    );
  }
}

class SingleChildScrollViewExample extends StatelessWidget {
  const SingleChildScrollViewExample({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: ColoredBox(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text('Header stuff'),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: ContentStuff(
                          left: const Checklist(),
                          right: const WorkArea(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Checklist extends StatefulWidget {
  const Checklist({super.key});

  @override
  State<Checklist> createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {
  int _numberOfItems = 10;

  void adjustItemCount(int amount) {
    setState(() {
      _numberOfItems = (_numberOfItems + amount) //
          .clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () => adjustItemCount(-1),
                child: const Text('-'),
              ),
              Text(_numberOfItems.toString()),
              ElevatedButton(
                onPressed: () => adjustItemCount(1),
                child: const Text('+'),
              ),
            ],
          ),
          for (int index = 0; index < _numberOfItems; index++) //
            Material(
              child: Container(
                color: Colors.red,
                child: SizedBox(
                  height: 25,
                  width: 100,
                  child: Checkbox(
                    value: false,
                    //Yes, I know they don't work, that's ok for this example.
                    onChanged: (bool? value) {},
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class WorkArea extends StatefulWidget {
  const WorkArea({super.key});

  @override
  State<WorkArea> createState() => _WorkAreaState();
}

class _WorkAreaState extends State<WorkArea> {
  double _height = 200;

  void adjustHeight(double amount) {
    setState(() {
      _height = (_height + amount).clamp(0, 500);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.teal,
      child: SizedBox(
        height: _height,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () => adjustHeight(-50),
              child: const Text('-'),
            ),
            Text(_height.toString()),
            ElevatedButton(
              onPressed: () => adjustHeight(50),
              child: const Text('+'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContentStuff extends MultiChildRenderObjectWidget {
  ContentStuff({
    super.key,
    required Widget left,
    required Widget right,
  }) : super(
          children: [
            LayoutId(id: 'left', child: left),
            LayoutId(id: 'right', child: right),
          ],
        );

  @override
  RenderObject createRenderObject(BuildContext context) => RenderContentStuff();
}

class RenderContentStuff extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  void performLayout() {
    final idToChild = getChildrenIdMap();

    Size layoutChild(Object key, BoxConstraints constraints) {
      final box = idToChild[key]!;
      box.layout(constraints, parentUsesSize: true);
      return box.size;
    }

    void positionChild(Object key, Offset position) {
      final box = idToChild[key]!;
      (box.parentData as MultiChildLayoutParentData).offset = position;
    }

    final leftWidth = idToChild['left']! //
        .getMaxIntrinsicWidth(double.infinity);

    final rightWidth = constraints.maxWidth - leftWidth;

    final rightSize = layoutChild(
      'right',
      BoxConstraints.tightFor(width: rightWidth),
    );

    positionChild(
      'right',
      Offset(constraints.maxWidth - rightSize.width, 0.0),
    );

    layoutChild(
      'left',
      BoxConstraints.tight(
        Size(leftWidth, rightSize.height),
      ),
    );

    positionChild('left', Offset.zero);

    size = Size(constraints.maxWidth, rightSize.height);
  }

  Map<Object, RenderBox> getChildrenIdMap() {
    final idToChild = <Object, RenderBox>{};
    RenderBox? child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as MultiChildLayoutParentData;
      idToChild[childParentData.id!] = child;
      child = childParentData.nextSibling;
    }
    return idToChild;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
