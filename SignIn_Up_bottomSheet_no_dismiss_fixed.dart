import 'package:flutter/material.dart';

class SignUpInView extends StatefulWidget {
  const SignUpInView({super.key});

  @override
  State<SignUpInView> createState() => _SignUpInViewState();
}

class _SignUpInViewState extends State<SignUpInView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;

  /// Animation opacity
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 100, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0, 0.65)));
    _controller.forward();
  }

  @override
  void dispose() {
    // disposed = true;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            elevation: 0,
            snap: true,
            floating: true,
            stretch: true,
            backgroundColor: Colors.grey.shade50,
            flexibleSpace: const FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              background: Center(
                child: FlutterLogo(
                    //fit: imagee for BoxFit.cover
                    ),
              ),
            ),
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child) {
                      return Transform.translate(
                        offset: Offset(0, animation.value),
                        child: Opacity(
                          opacity: opacity.value,
                          child: Transform.translate(
                            offset: const Offset(0, 1),
                            child: Container(
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                  child: Container(
                                width: 50,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                              )),
                            ),
                          ),
                        ),
                      );
                    })),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0, animation.value),
                    child: Opacity(
                      opacity: opacity.value,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.85,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //fadeINUP from 60
                                Text("hi")
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ]))
        ],
      ),
    );
  }
}
