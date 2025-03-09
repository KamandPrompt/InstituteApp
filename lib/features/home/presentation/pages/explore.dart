import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/domain/entities/feed_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/feed_page_bloc/feed_bloc.dart';

//for detail
import 'package:uhl_link/features/home/presentation/widgets/feeddetail_page.dart';

class FeedPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
  const FeedPage({super.key, required this.isGuest, required this.user});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3));
    BlocProvider.of<FeedBloc>(context).add(const GetFeedItemsEvent());
  }

  @override
  void dispose() {
    log("disposed");
    super.dispose();
  }

  List<FeedItemEntity> feedItems = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        SizedBox(
            width: screenSize.width,
            height: screenSize.height,

            // resizeToAvoidBottomInset: false,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: BlocBuilder<FeedBloc, FeedState>(
                  builder: (context, state) {
                    if (state is FeedItemsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FeedItemsLoaded) {
                      feedItems = state.items;
                      return ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        primary: false,
                        //no of items
                        itemCount: feedItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          //----------------------feedItemCard---------------------------------
                          return feedItemCard(context, index, screenSize);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 20,
                          );
                        },
                      );
                    } else if (state is FeedItemsLoadingError) {
                      return const Center(
                          child: Text('Failed to load feed items',
                              style: TextStyle(color: Colors.red)));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ))),
        widget.isGuest
            ? Container()
            : Positioned(
                right: 0,
                bottom: 0,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                        UhlLinkRoutesNames.feedAddItemPage,
                        pathParameters: {"user": jsonEncode(widget.user)});
                  },
                  label: Text('Add Events',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 14)),
                  icon: Icon(Icons.add_box_rounded,
                      size: 20, color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
      ],
    );
  }

  Card feedItemCard(BuildContext context, int index, Size screenSize) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02,
          horizontal: MediaQuery.of(context).size.height * 0.02,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns content to the start
              children: [
                CarouselSlider(
                  items: feedItems[index]
                      .images
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
                                      MediaQuery.of(context).size.height * 0.25,
                                  errorBuilder: (context, object, stacktrace) {
                                return Icon(Icons.error_outline_rounded,
                                    size: 40,
                                    color: Theme.of(context).primaryColor);
                              }, fit: BoxFit.cover),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      height: screenSize.height * 0.3,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 5),
                      enlargeCenterPage: true),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Ensures text aligns to the left
                  children: [
                    Text("Event Name",
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).primaryColor)),

                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.008),
                    Text(feedItems[index].host,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.008),
                    Text(
                      feedItems[index].description.length > 60
                          ? '${feedItems[index].description.substring(0, 60)}...'
                          : feedItems[index].description,
                      textAlign: TextAlign.start,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),

                    SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.01), // Space between text and View More
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailPage(
                                    images: feedItems[index].images,
                                    hostname: feedItems[index].host,
                                    description: feedItems[index].description,
                                    registerLink: feedItems[index].link)));
                      },
                      child: Text(
                        "View more...",
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.blue.shade800,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
