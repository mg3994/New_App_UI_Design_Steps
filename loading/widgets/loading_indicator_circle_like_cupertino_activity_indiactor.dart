const double _kDefaultIndicatorRadius = 35.0;

class AntinnaActivityIndicator extends StatefulWidget {
  const AntinnaActivityIndicator({
    super.key,
    this.color,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
    this.backgroundColor = const Color(0xFF303030),
  })  : assert(radius > 0.0),
        progress = 1.0,
        bubbleRadius = (radius / 35) * 3;

  const AntinnaActivityIndicator.partiallyRevealed({
    super.key,
    this.color,
    this.radius = _kDefaultIndicatorRadius,
    this.progress = 1.0,
    this.backgroundColor = const Color(0xFF303030),
  })  : assert(radius > 0.0),
        assert(progress >= 0.0 && progress <= 1.0),
        animating = false,
        bubbleRadius = (radius / 35) * 3;

  final Color? color;
  final bool animating;
  final double radius;
  final double progress;
  final Color backgroundColor;
  final double bubbleRadius;

  @override
  State<AntinnaActivityIndicator> createState() => _AntinnaActivityIndicatorState();
}

class _AntinnaActivityIndicatorState extends State<AntinnaActivityIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AntinnaActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.radius,
      height: widget.radius,
      decoration: BoxDecoration(shape: BoxShape.circle, color: widget.backgroundColor),
      child: CustomPaint(
        painter: _AntinnaActivityIndicatorPainter(
          bubbleRadius: widget.bubbleRadius,
          position: _controller,
          activeColor: widget.color ?? Colors.white.withOpacity(0.2),
          radius: widget.radius,
          progress: widget.progress,
        ),
      ),
    );
  }
}

const List<int> _kAlphaValues = <int>[47, 47, 47, 47, 72, 97, 122, 147];

class _AntinnaActivityIndicatorPainter extends CustomPainter {
  _AntinnaActivityIndicatorPainter({
    required this.bubbleRadius,
    required this.position,
    required this.activeColor,
    required this.radius,
    required this.progress,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius / _kDefaultIndicatorRadius,
          -radius / 3.0,
          radius / _kDefaultIndicatorRadius,
          -radius,
          radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
        ),
        super(repaint: position);

  final Animation<double> position;
  final Color activeColor;
  final double radius;
  final double progress;
  final double bubbleRadius;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final bubbleCount = _kAlphaValues.length;
    const int _partiallyRevealedAlpha = 147;
    final arcBetweenBubbles = (2 * pi) / bubbleCount;
    final Paint paint = Paint();
    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);
    final int activeBubble = (bubbleCount * position.value).floor();

    for (var i = 0; i < bubbleCount * progress; i += 1) {
      final int t = (i - activeBubble) % bubbleCount;
      paint.color = activeColor.withAlpha(progress < 1 ? _partiallyRevealedAlpha : _kAlphaValues[t]);
      canvas.drawCircle(
        Offset(cos(i * arcBetweenBubbles) * radius / 4, sin(i * arcBetweenBubbles) * radius / 4),
        bubbleRadius,
        paint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AntinnaActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position ||
        oldPainter.activeColor != activeColor ||
        oldPainter.progress != progress ||
        oldPainter.bubbleRadius != bubbleRadius;
  }
}
