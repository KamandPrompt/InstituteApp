import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/domain/entities/feed_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/feed_page_bloc/feed_bloc.dart';
import 'package:uhl_link/features/home/presentation/widgets/feed_detail_page.dart';

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
    Future.delayed(Duration(seconds: 2));
    BlocProvider.of<FeedBloc>(context).add(const GetFeedItemsEvent());
  }

  List<FeedItemEntity> feedItems = [];

  @override
  Widget build(BuildContext context) {
    String porsString = dotenv.env["POR_EMAILS"] ?? "";
    List<String> pors = porsString.split(',');
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedItemsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FeedItemsLoaded) {
              feedItems = state.items;
              if (feedItems.isEmpty) {
                return Center(
                    child: Text('No feeds available',
                        style: Theme.of(context).textTheme.labelSmall));
              }
              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                primary: true,
                itemCount: feedItems.length,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.09),
                itemBuilder: (BuildContext context, int index) {
                  return feedItemCard(context, index);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              );
            } else if (state is FeedItemsLoadingError) {
              return const Center(
                  child: Text('Failed to load feed items.',
                      style: TextStyle(color: Colors.red)));
            } else if (state is FeedItemAdded ||
                state is FeedItemsAddingError) {
              BlocProvider.of<FeedBloc>(context).add(const GetFeedItemsEvent());
              return CircularProgressIndicator();
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        !widget.isGuest && pors.contains(widget.user!["email"])
            ? Positioned(
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
              ) : Container(),
      ],
    );
  }

  Card feedItemCard(BuildContext context, int index) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                                        .withValues(alpha: 0.2),
                                    width: 1.5,
                                  )),
                              child: CachedNetworkImage(imageUrl: image,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  errorWidget: (context, object, stacktrace) {
                                return Icon(Icons.error_outline_rounded,
                                    size: 40,
                                    color: Theme.of(context).primaryColor);
                              }, fit: BoxFit.cover),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.3,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      autoPlayInterval: const Duration(seconds: 5),
                      enlargeCenterPage: true),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(feedItems[index].title,
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.001),
                      Text(
                        feedItems[index].description.trim(),
                        textAlign: TextAlign.start,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.001),
                      Text(feedItems[index].host,
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: Theme.of(context).textTheme.labelSmall),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.001), // Space between text and View More
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedDetailPage(
                                      images: feedItems[index].images,
                                      host: feedItems[index].host,
                                      description: feedItems[index].description,
                                      link: feedItems[index].link,
                                      title: feedItems[index].title)));
                        },
                        child: Text("View more...",
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
