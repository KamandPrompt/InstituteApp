import 'dart:async';

import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final Text text;
  final double velocity;

  const MarqueeText({required this.text, this.velocity = 60.0, super.key});

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late ScrollController _scrollController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startMarquee();
  }

  void _startMarquee() {
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.offset;
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0.0);
        } else {
          _scrollController.animateTo(
            currentScroll + widget.velocity * 0.02,
            duration: Duration(milliseconds: 10),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      physics: NeverScrollableScrollPhysics(),
      // hitTestBehavior: HitTestBehavior.translucent,
      child: widget.text,
    );
  }
}
