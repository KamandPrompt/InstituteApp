import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/home/domain/entities/lost_found_item_entity.dart';
import 'package:vertex/features/home/presentation/bloc/lost_found_bloc/lnf_bloc.dart';
import 'package:vertex/utils/functions.dart';

class LostFoundPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
  const LostFoundPage({super.key, required this.isGuest, required this.user});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3));
    BlocProvider.of<LnfBloc>(context).add(const GetLostFoundItemsEvent());
  }

  List<LostFoundItemEntity> lnfItems = [];

  Widget lnfTagWidget({required String tag}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: tag == 'Found' ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        tag,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: tag == 'Found' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text("Lost and Found",
              style: Theme.of(context).textTheme.bodyMedium),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: BlocBuilder<LnfBloc, LnfState>(
            builder: (context, state) {
              if (state is LnfItemsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LnfItemsLoaded) {
                lnfItems = state.items;
                if (lnfItems.isEmpty) {
                  return Center(
                    child: Text(
                      "No items found",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                lnfItems
                    .sort((first, second) => second.date.compareTo(first.date));
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  primary: true,
                  itemCount: lnfItems.length,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.09),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Theme.of(context).cardColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(100),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          lnfItems[index].images.isNotEmpty
                              ? CarouselSlider(
                                  items: lnfItems[index]
                                      .images
                                      .map((image) => ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15)),
                                            child: CachedNetworkImage(
                                                imageUrl: image,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    20,
                                                placeholder: (context,
                                                        url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget: (context, object,
                                                    stacktrace) {
                                                  return Icon(
                                                      Icons
                                                          .error_outline_rounded,
                                                      size: 40,
                                                      color: Theme.of(context)
                                                          .primaryColor);
                                                },
                                                fit: BoxFit.cover),
                                          ))
                                      .toList(),
                                  options: CarouselOptions(
                                      height: screenSize.height * 0.3,
                                      autoPlay: true,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 1,
                                      autoPlayInterval:
                                          const Duration(seconds: 5),
                                      enlargeCenterPage: true))
                              : Container(),
                          // lnfItems[index].images.isNotEmpty
                          //     ? SizedBox(
                          //         height:
                          //             MediaQuery.of(context).size.height * 0.01,
                          //       )
                          //     : Container(),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.height * 0.015,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.015),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    lnfTagWidget(
                                        tag: lnfItems[index].lostOrFound),
                                    Text(
                                        DateFormat.yMMMMd()
                                            .format(lnfItems[index].date),
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall)
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(lnfItems[index].name,
                                              textAlign: TextAlign.start,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17)),
                                          SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.005),
                                          Text(lnfItems[index].phoneNo,
                                              textAlign: TextAlign.start,
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(fontSize: 17))
                                        ]),
                                    IconButton(
                                        onPressed: () async {
                                          await makePhoneCall(
                                              lnfItems[index].phoneNo);
                                        },
                                        icon: CircleAvatar(
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withAlpha(50),
                                          child: Icon(Icons.phone_rounded,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005),
                                Text(
                                  lnfItems[index].description,
                                  textAlign: TextAlign.justify,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withAlpha(180),
                                      ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                );
              } else if (state is LnfItemsLoadingError) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LnfItemAdded ||
                  state is LnfItemsAddingError) {
                BlocProvider.of<LnfBloc>(context)
                    .add(const GetLostFoundItemsEvent());
                return CircularProgressIndicator();
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
        floatingActionButton: widget.isGuest
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(right: 0, bottom: 5),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                        UhlLinkRoutesNames.lostFoundAddItemPage,
                        pathParameters: {"user": jsonEncode(widget.user)});
                  },
                  label: Text('Add Item',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16)),
                  icon: Icon(Icons.add_box_rounded,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ));
  }
}
