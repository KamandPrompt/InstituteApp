import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final dynamic icon;
  final void Function() onTap;
  final int maxLines;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.maxLines = 1,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  @override
  Widget build(BuildContext context) {
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: EdgeInsets.zero,
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: aspectRatio * 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: aspectRatio * 10),
              CircleAvatar(
                backgroundColor: widget.icon.runtimeType == IconData ? Theme.of(context).primaryColor.withAlpha(50) : Colors.white,
                radius: widget.icon.runtimeType == IconData ? aspectRatio * 55 : aspectRatio * 80,
                child: widget.icon.runtimeType == IconData
                    ? Icon(widget.icon,
                        size: aspectRatio * 55,
                        color: Theme.of(context).colorScheme.primary)
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(aspectRatio * 80),
                      child: CachedNetworkImage(
                          imageUrl: widget.icon,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          errorWidget: (context, object, stacktrace) {
                            return Icon(Icons.error_outline_rounded,
                                size: 40, color: Theme.of(context).primaryColor);
                          },
                        ),
                    ),
              ),
              SizedBox(height: aspectRatio * 20),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: widget.maxLines,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                    ),
              ),
              SizedBox(height: aspectRatio * 10),
            ],
          ),
        ),
      ),
    );
  }
}
