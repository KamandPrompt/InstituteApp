import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/home/domain/entities/feed_entity.dart';
import 'package:vertex/features/home/presentation/bloc/feed_page_bloc/feed_bloc.dart';
import 'package:vertex/features/home/presentation/widgets/feed_detail_page.dart';
import 'package:vertex/utils/env_utils.dart';

class EventsPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic> user;

  const EventsPage({super.key, required this.isGuest, required this.user});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2));
    BlocProvider.of<FeedBloc>(context).add(const GetFeedItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          "Events",
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedItemsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FeedItemsLoaded) {
                  List<FeedItemEntity> eventItems = state.items;
                  if (eventItems.isEmpty) {
                    return Center(
                      child: Text(
                        'No events available',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    );
                  }
                  eventItems.sort((first, second) =>
                      second.createdAt.compareTo(first.createdAt));
                  return ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    primary: true,
                    itemCount: eventItems.length,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.09),
                    itemBuilder: (BuildContext context, int index) {
                      return eventItems[index].type == "Event"
                          ? eventItemCard(context, index, eventItems)
                          : Container();
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return eventItems[index].type == "Event"
                          ? SizedBox(height: 10)
                          : Container();
                    },
                  );
                } else if (state is FeedItemsLoadingError) {
                  return const Center(
                    child: Text(
                      'Failed to load events.\n Check your internet connection.',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is FeedItemAdded ||
                    state is FeedItemsAddingError) {
                  BlocProvider.of<FeedBloc>(context)
                      .add(const GetFeedItemsEvent());
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            FutureBuilder(
                future: isAdmin(widget.user['email']),
                builder: (context, snapshot) {
                  return (!widget.isGuest &&
                          snapshot.hasData &&
                          snapshot.data == true)
                      ? Positioned(
                          right: 10,
                          bottom: 10,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              GoRouter.of(context).pushNamed(
                                UhlLinkRoutesNames.feedAddItemPage,
                                pathParameters: {
                                  "user": jsonEncode(widget.user)
                                },
                              );
                            },
                            label: Text(
                              'Add Events',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 14),
                            ),
                            icon: Icon(
                              Icons.add_box_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Container();
                })
          ],
        ),
      ),
    );
  }

  Card eventItemCard(
      BuildContext context, int index, List<FeedItemEntity> eventItems) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
            width: 1.5,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          eventItems[index].images.isNotEmpty
              ? CarouselSlider(
                  items: eventItems[index]
                      .images
                      .map((image) => ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: image,
                              height: screenHeight * 0.25,
                              width: screenWidth - 20,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(
                                  value: progress.progress,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              errorWidget: (context, object, stacktrace) {
                                return Icon(
                                  Icons.error_outline_rounded,
                                  size: 40,
                                  color: Theme.of(context).primaryColor,
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    height: screenHeight * 0.3,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                    autoPlayInterval: const Duration(seconds: 5),
                    enlargeCenterPage: true,
                  ),
                )
              : Container(),
          // eventItems[index].images.isNotEmpty
          //     ? SizedBox(
          //         height: MediaQuery.of(context).size.height * 0.02)
          //     : Container(),
          Container(
            width: screenWidth - 20,
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.015,
                vertical: MediaQuery.of(context).size.height * 0.015),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eventItems[index].title,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 20)),
                SizedBox(height: screenHeight * 0.005),
                Text(eventItems[index].description.trim(),
                    textAlign: TextAlign.justify,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(180))),
                SizedBox(height: screenHeight * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(eventItems[index].host,
                        textAlign: TextAlign.start,
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(fontSize: 17)),
                    Text(
                        DateFormat.yMMMMd().format(eventItems[index].createdAt),
                        textAlign: TextAlign.end,
                        softWrap: true,
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                SizedBox(
                    height: screenHeight *
                        0.005), // Space between text and View More
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedDetailPage(
                                type: eventItems[index].type,
                                images: eventItems[index].images,
                                host: eventItems[index].host,
                                description: eventItems[index].description,
                                link: eventItems[index].link,
                                title: eventItems[index].title,
                                createdAt: eventItems[index].createdAt)));
                  },
                  child: Text("View more...",
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Theme.of(context).primaryColor)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
