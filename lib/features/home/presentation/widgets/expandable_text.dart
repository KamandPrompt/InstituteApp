import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle style;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 3,
    required this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  late String firstHalf;
  late String secondHalf;
  final GlobalKey _textKey = GlobalKey();
  bool _isTextOverflow = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final textRenderBox =
          _textKey.currentContext?.findRenderObject() as RenderBox?;
      if (textRenderBox != null) {
        setState(() {
          _isTextOverflow = textRenderBox.size.height >=
              widget.trimLines * widget.style.fontSize!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = Text(
      widget.text,
      key: _textKey,
      textAlign: TextAlign.justify,
      softWrap: true,
      style: widget.style,
      maxLines: _readMore ? widget.trimLines : null,
      overflow: _readMore ? TextOverflow.ellipsis : TextOverflow.visible,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text,
        if (_isTextOverflow)
          GestureDetector(
            onTap: () => setState(() => _readMore = !_readMore),
            child: Text(
              _readMore ? 'Read more' : 'Show less',
              style:
                  widget.style.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
      ],
    );
  }
}
