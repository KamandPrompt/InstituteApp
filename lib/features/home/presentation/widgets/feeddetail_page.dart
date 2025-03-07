import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailPage extends StatefulWidget {
  final List<String> images;
  final String hostname;
  final String description;
  final String registerLink;

  EventDetailPage({
    required this.images,
    required this.hostname,
    required this.description,
    required this.registerLink,
  });

  @override
  _EventDetailPageState createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Event Details",
            style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
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
                                            .withOpacity(0.2),
                                        width: 1.5,
                                      )),
                                  child: Image.file(File(image),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25, errorBuilder:
                                          (context, object, stacktrace) {
                                    return Icon(Icons.error_outline_rounded,
                                        size: 40,
                                        color: Theme.of(context).primaryColor);
                                  }, fit: BoxFit.cover),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images.asMap().entries.map((entry) {
                      return Container(
                        width: screenWidth * 0.02,
                        height: screenWidth * 0.02,
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(
                              _currentCarouselIndex == entry.key ? 0.9 : 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Event Details
              Text(
                'Hosted by',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15 * textScale * (screenWidth / 360),
                    ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                widget.hostname,
                style: TextStyle(
                  fontSize: 24 * textScale * (screenWidth / 360),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Description Card
              Card(
                color: Theme.of(context).cardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: ReadMoreText(
                    widget.description,
                    trimLines: 3,
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context)
                                    .scaffoldBackgroundColor
                                    .computeLuminance() >
                                0.5
                            ? Colors.black
                            : Colors.white),
                    moreStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 16 * textScale * (screenWidth / 360),
                      fontWeight: FontWeight.bold,
                    ),
                    lessStyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16 * textScale * (screenWidth / 360),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Move button to the bottom
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.06,
          child: ElevatedButton(
            onPressed: () async {
              Uri uri = Uri.parse(widget.registerLink);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context)
                                .scaffoldBackgroundColor
                                .computeLuminance() >
                            0.5
                        ? Colors.black
                        : Colors.white,
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      "Could not launch",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
              ),
            ),
            child: Text(
              'Register Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18 * textScale * (screenWidth / 360),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
