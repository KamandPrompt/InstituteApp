import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
//dependecies
//-readmore
//url launcher
//-cached_network_images

class EventDetailPage extends StatefulWidget {
  final List<String> images;
  final String hostname;
  final String description;
  final String registerLink;

  EventDetailPage(
      {required this.images,
      required this.hostname,
      required this.description,
      required this.registerLink});

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // 4% of screen width
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel Section
              Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.3, // 30% of screen height
                    child: CarouselSlider(
                      items: widget.images.map((img) {
                        return CachedNetworkImage(
                          imageUrl: img.replaceFirst('600x300', '800x400'),
                          fit: BoxFit.contain,
                          width: double.infinity,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Container(
                            height: screenHeight * 0.3,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress.progress,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey.shade200,
                            height: screenHeight * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: screenWidth * 0.1,
                                  color: Colors.grey,
                                ),
                                Text('Failed to load image',
                                    style: TextStyle(
                                        fontSize: 12 *
                                            textScale *
                                            (screenWidth / 360),
                                        color: Colors.grey)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        height: screenHeight / 2,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentCarouselIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // 2% of screen height
                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.images.asMap().entries.map((entry) {
                      return Container(
                        width: screenWidth * 0.02, // 2% of screen width
                        height: screenWidth * 0.02,
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(
                            _currentCarouselIndex == entry.key ? 0.9 : 0.4,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03), // 3% of screen height

              // Event Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hosted by',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14 * textScale * (screenWidth / 360),
                        ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    widget.hostname,
                    style: TextStyle(
                      fontSize: 28 * textScale * (screenWidth / 360),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 16 * textScale * (screenWidth / 360),
                              height: 1.5,
                            ),
                        moreStyle: TextStyle(
                          fontSize: 16 * textScale * (screenWidth / 360),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Register Button
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.9, // 90% of screen width
                      height: screenHeight * 0.06, // 6% of screen height
                      child: ElevatedButton(
                        onPressed: () async {
                          Uri uri = Uri.parse(widget.registerLink);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.externalApplication);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    Theme.of(context).dialogBackgroundColor,
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                  "Could not launch",
                                  style: (TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor)),
                                ),
                                duration: const Duration(
                                    seconds: 2), // Duration before auto-dismiss
                              ),
                            );
                            throw 'Could not launch';
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.04),
                          ),
                        ),
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18 * textScale * (screenWidth / 360),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
