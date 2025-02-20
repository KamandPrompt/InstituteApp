import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const DashboardCard(
      {super.key, required this.title, required this.icon, required this.onTap});

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
            borderRadius: BorderRadius.circular(6),
          ),
          clipBehavior: Clip.hardEdge,
          color: Theme.of(context).primaryColor,
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: aspectRatio * 55,
                  color: Theme.of(context).colorScheme.onPrimary),
              SizedBox(height: aspectRatio * 30),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
