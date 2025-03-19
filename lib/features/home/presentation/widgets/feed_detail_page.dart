import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedDetailPage extends StatefulWidget {
  final List<String> images;
  final String title;
  final String description;
  final String link;
  final String host;

  const FeedDetailPage({
    super.key,
    required this.images,
    required this.host,
    required this.description,
    required this.link,
    required this.title,
  });

  @override
  State<FeedDetailPage> createState() => _FeedDetailPageState();
}

class _FeedDetailPageState extends State<FeedDetailPage> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title:
            Text("Feed Details", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel Section
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.3, // 30% of screen height
                    child: CarouselSlider(
                      items: widget.images
                          .map((image) => ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .cardColor
                                            .withValues(alpha: 0.2),
                                        width: 1.5,
                                      )),
                                  child: CachedNetworkImage(
                                      imageUrl: image,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      errorWidget:
                                          (context, object, stacktrace) {
                                        return Icon(Icons.error_outline_rounded,
                                            size: 40,
                                            color:
                                                Theme.of(context).primaryColor);
                                      },
                                      fit: BoxFit.cover),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                          height: screenHeight * 0.3,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          autoPlayInterval: const Duration(seconds: 5),
                          enlargeCenterPage: true),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Dots Indicator
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images.asMap().entries.map((entry) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: _currentCarouselIndex == entry.key
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.scrim,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              // Event Details
              Text(widget.title,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 20 * textScale * (screenWidth / 360))),
              SizedBox(height: screenHeight * 0.01),
              Text(
                widget.description,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(fontSize: 15 * textScale * (screenWidth / 360)),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text("By ${widget.host}",
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 16 * textScale * (screenWidth / 360),
                      color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Uri uri = Uri.parse(widget.link);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).cardColor,
                content: Text(
                  "Could not launch",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            );
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          'Link',
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 15),
        ),
      ),
    );
  }
}
