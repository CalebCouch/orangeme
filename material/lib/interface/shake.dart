import 'package:material/material.dart';
import 'dart:math';

class ShakeWidget extends StatefulWidget {
    const ShakeWidget({
        super.key,
        required this.child,
        required this.controller,
        this.duration = const Duration(milliseconds: 800), // Increased duration
        this.deltaX = 6, // Slightly increased horizontal movement
        this.oscillations = 4, // Fewer oscillations for more steady shaking
        this.curve = Curves.easeInOut, // Changed to easeInOut for smoother transitions
    });

    final Duration duration;
    final double deltaX;
    final int oscillations;
    final Widget child;
    final Curve curve;
    final controller;

    @override
    ShakeWidgetState createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _animation;

    @override
    void initState() {
        super.initState();
        _animationController = AnimationController(
            vsync: this,
            duration: widget.duration,
        );

        _animation = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: _animationController, curve: widget.curve),
        );

        widget.controller.addListener(_startShaking);
    }

    @override
    void dispose() {
        widget.controller.removeListener(_startShaking);
        _animationController.dispose();
        super.dispose();
    }

    void _startShaking() {
        _animationController.forward(from: 0);
    }

  double _wave(double t) => sin(widget.oscillations * 2 * pi * t) * (1 - (2 * t - 1).abs());

    @override
    Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.translate(
            offset: Offset(
                widget.deltaX * _wave(_animation.value),
                0,
            ),
            child: widget.child,
        ),
        child: widget.child,
    );
}
