// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ScreenWidthButton extends StatefulWidget {
  final String text;
  final Function() buttonFunc;
  bool isLoading;
  ScreenWidthButton(
      {super.key,
      required this.text,
      required this.buttonFunc,
      this.isLoading = false});

  @override
  State<ScreenWidthButton> createState() => _ScreenWidthButtonState();
}

class _ScreenWidthButtonState extends State<ScreenWidthButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.buttonFunc();
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 46,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.scrim,
              blurRadius: 20.0,
              spreadRadius: -20.0,
              offset: const Offset(0.0, 20.0),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white)),
            widget.isLoading ? const SizedBox(width: 20) : const SizedBox(),
            widget.isLoading
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        strokeWidth: 3))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
