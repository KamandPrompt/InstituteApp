import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import 'package:vertex/features/home/presentation/bloc/post_bloc/post_bloc.dart';
import 'package:vertex/features/home/presentation/widgets/post_detail_page.dart';
import 'package:vertex/utils/env_utils.dart';

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
    BlocProvider.of<PostBloc>(context).add(const GetPostItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostItemsLoading ||
                state is PostInitial ||
                state is PostItemDeleting) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostItemsLoaded) {
              List<PostItemEntity> feedItems =
                  state.items.where((post) => post.type == "Feed").toList();
              if (feedItems.isEmpty) {
                return Center(
                    child: Text('No feeds available.',
                        style: Theme.of(context).textTheme.bodySmall));
              }
              feedItems.sort((first, second) =>
                  second.createdAt.compareTo(first.createdAt));
              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                primary: true,
                itemCount: feedItems.length,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.09),
                itemBuilder: (BuildContext context, int index) {
                  return feedItems[index].type == "Feed"
                      ? feedItemCard(context, index, feedItems)
                      : Container();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              );
            } else if (state is PostItemsLoadingError) {
              return const Center(
                  child: Text(
                      'Failed to load feed items.\n Check your internet connection.',
                      style: TextStyle(color: Colors.red)));
            } else if (state is PostItemAddedOrEdited ||
                state is PostItemsAddingOrEditingError ||
                state is PostItemDeletedSuccessfully ||
                state is PostItemDeleteError) {
              BlocProvider.of<PostBloc>(context).add(const GetPostItemsEvent());
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        FutureBuilder(
            future: isAdmin(widget.user?['email'] ?? ""),
            builder: (context, snapshot) {
              return (!widget.isGuest &&
                      widget.user != null &&
                      snapshot.hasData &&
                      snapshot.data == true)
                  ? Positioned(
                      right: 5,
                      bottom: 5,
                      child: GestureDetector(
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                              UhlLinkRoutesNames.postAddOrEditItemPage,
                              extra: {
                                "user": widget.user,
                                "postEditing": false,
                              });
                        },
                        child: CircleAvatar(
                          radius: aspectRatio * 60,
                          backgroundColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                          child: Icon(Icons.add_rounded,
                              size: aspectRatio * 90,
                              color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ))
                  : Container();
            }),
      ],
    );
  }

  Card feedItemCard(
      BuildContext context, int index, List<PostItemEntity> feedItems) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double aspectRatio = screenWidth / screenHeight;
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
            width: 1.5,
          )),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              feedItems[index].images.isNotEmpty
                  ? CarouselSlider(
                      items: feedItems[index]
                          .images
                          .map((image) => ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: CachedNetworkImage(
                                    imageUrl: image,
                                    height: screenHeight * 0.25,
                                    width: screenWidth - 20,
                                    placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget: (context, object, stacktrace) {
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
                          enlargeCenterPage: true),
                    )
                  : Container(),
              // feedItems[index].images.isNotEmpty
              //     ? SizedBox(height: MediaQuery.of(context).size.height * 0.02)
              //     : Container(),

              Container(
                width: MediaQuery.of(context).size.width - 20,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.height * 0.015,
                    vertical: MediaQuery.of(context).size.height * 0.015),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(feedItems[index].title,
                        textAlign: TextAlign.start,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: screenHeight * 0.005),
                    Text(feedItems[index].description.trim(),
                        textAlign: TextAlign.justify,
                        softWrap: true,
                        maxLines: 4,
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
                        Text(feedItems[index].host,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontSize: 17)),
                        Text(
                            DateFormat.yMMMMd()
                                .format(feedItems[index].createdAt),
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
                                builder: (context) => PostDetailPage(
                                    type: feedItems[index].type,
                                    images: feedItems[index].images,
                                    host: feedItems[index].host,
                                    description: feedItems[index].description,
                                    link: feedItems[index].link,
                                    title: feedItems[index].title,
                                    createdAt: feedItems[index].createdAt)));
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
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton(
              icon: CircleAvatar(
                radius: aspectRatio * 40,
                backgroundColor:
                    Theme.of(context).colorScheme.onPrimary.withAlpha(100),
                child: Icon(Icons.more_vert_rounded,
                    size: aspectRatio * 60,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                  width: 1,
                ),
              ),
              onSelected: (value) async {
                if (widget.isGuest) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'You need to login to edit/delete feeds.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                  );
                  return;
                }
                bool canEditDelete = await isAdmin(widget.user!['email']);
                if (canEditDelete == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "You don't have access to edit/delete feeds.",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                  );
                  return;
                }
                if (value == 1) {
                  GoRouter.of(context).pushNamed(
                      UhlLinkRoutesNames.postAddOrEditItemPage,
                      extra: {
                        "user": widget.user,
                        "postEditing": true,
                        "postDetails": feedItems[index]
                      });
                } else if (value == 2) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Feed',
                            style: Theme.of(context).textTheme.bodyMedium),
                        content: Text(
                            'Are you sure you want to delete this feed item?',
                            style: Theme.of(context).textTheme.labelSmall),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel',
                                style: Theme.of(context).textTheme.labelSmall),
                          ),
                          TextButton(
                            onPressed: () {
                              BlocProvider.of<PostBloc>(context).add(
                                  DeletePostItemEvent(id: feedItems[index].id));
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.onError,
                                      fontWeight: FontWeight.w700,
                                    )),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                PopupMenuItem<int>(
                  value: 1,
                  child: Text('Edit',
                      style: Theme.of(context).textTheme.labelSmall),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text('Delete',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onError,
                          )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
