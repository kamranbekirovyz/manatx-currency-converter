import 'package:flutter/material.dart';

class SlideRightToLeft extends StatefulWidget {
  final Widget child;

  const SlideRightToLeft({
    required this.child,
  });

  @override
  State<SlideRightToLeft> createState() => _SlideRightToLeftState();
}

class _SlideRightToLeftState extends State<SlideRightToLeft> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      end: Offset.zero,
      begin: const Offset(0.75, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
