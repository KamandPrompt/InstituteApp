import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const DashboardCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: (width - 30 - 10) / 3,
      width: (width - 30 - 10) / 3,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              width: 1,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).cardColor,
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withAlpha(50),
                radius: aspectRatio * 55,
                child: Icon(widget.icon,
                    size: aspectRatio * 55,
                    color: Theme.of(context).colorScheme.primary),
              ),
              SizedBox(height: aspectRatio * 20),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
