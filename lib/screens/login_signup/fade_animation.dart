import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final double delay;
  final Widget child;

  FadeAnimation({required this.delay,required this.child});

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: (500 * widget.delay).round()), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: Duration(milliseconds: 500),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        transform: _visible
            ? Matrix4.translationValues(0, 0, 0)
            : Matrix4.translationValues(0, -30, 0),
        child: widget.child,
      ),
    );
  }
}
