import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetailPage extends StatefulWidget {
  final String type;
  final List<String> images;
  final String title;
  final String description;
  final String link;
  final String host;
  final DateTime createdAt;

  const PostDetailPage({
    super.key,
    required this.type,
    required this.images,
    required this.host,
    required this.description,
    required this.link,
    required this.title,
    required this.createdAt,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaler.scale(1);
    // widget.images.clear();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("${widget.type} Details",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 15),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel Section
              widget.images.isNotEmpty
                  ? SizedBox(
                      height: screenHeight * 0.3, // 30% of screen height
                      child: CarouselSlider(
                        items: widget.images
                            .map((image) => ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                      imageUrl: image,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                      progressIndicatorBuilder: (context, url,
                                              progress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                      errorWidget:
                                          (context, object, stacktrace) {
                                        return Icon(Icons.error_outline_rounded,
                                            size: 40,
                                            color:
                                                Theme.of(context).primaryColor);
                                      },
                                      fit: BoxFit.cover),
                                ))
                            .toList(),
                        options: CarouselOptions(
                            height: screenHeight * 0.3,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            autoPlayInterval: const Duration(seconds: 5),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentCarouselIndex = index;
                              });
                            },
                            enlargeCenterPage: true),
                      ),
                    )
                  : Container(),
              widget.images.isNotEmpty
                  ? SizedBox(height: screenHeight * 0.01)
                  : Container(),
              // Dots Indicator
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: screenHeight * 0.01),
                    Text(DateFormat.yMMMMd().format(widget.createdAt),
                        textAlign: TextAlign.end,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelSmall),
              // Event Details
              Text(widget.title,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 25 * textScale * (screenWidth / 360))),
              SizedBox(height: screenHeight * 0.01),
              Text(widget.description,
                  textAlign: TextAlign.justify,
                  softWrap: true,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 15 * textScale * (screenWidth / 360),
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(200))),
              SizedBox(height: screenHeight * 0.01),
              Text("By ${widget.host}",
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontSize: 18 * textScale * (screenWidth / 360),
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Uri uri = Uri.parse(widget.link);
            // bool canLaunchUri = await canLaunchUrl(uri);
            try {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).cardColor,
                  content: Text(
                    "No link found.",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              );
            }
          },
          shape: CircleBorder(
            side: BorderSide(
              color: Theme.of(context).primaryColor.withAlpha(100),
              width: 1.5,
            ),
          ),
          backgroundColor: Theme.of(context).cardColor,
          child: Icon(Icons.link_rounded,
              size: 28, color: Theme.of(context).primaryColor)
          ),
    );
  }
}
