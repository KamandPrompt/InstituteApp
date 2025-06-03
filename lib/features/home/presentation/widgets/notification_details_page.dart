import 'package:flutter/material.dart';
import 'package:vertex/features/home/domain/entities/notifications_entity.dart';
import 'package:vertex/widgets/marquee_text.dart';

class NotificationDetailsPage extends StatelessWidget {
  final Map<String, dynamic> notificationMap;

  const NotificationDetailsPage({super.key, required this.notificationMap});

  @override
  Widget build(BuildContext context) {
    NotificationEntity notification =
        NotificationEntity.fromJson(notificationMap);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.only(right: width * 0.08),
            child: MarqueeText(
              text: Text(
                "  ${notification.title}  ",
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )),
        centerTitle: true,
      ),
      body: SizedBox(
        width: width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: width,
                child: Text(
                  notification.by,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ),
              const SizedBox(height: 12),
              if (notification.image != null && notification.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    notification.image!,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 50,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                notification.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}