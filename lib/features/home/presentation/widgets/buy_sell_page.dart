import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/domain/entities/buy_sell_item_entity.dart';
import 'package:vertex/features/home/presentation/bloc/buy_sell_bloc/bns_bloc.dart';
import 'package:vertex/features/home/presentation/widgets/expandable_text.dart';
import 'package:vertex/utils/env_utils.dart';
import 'package:vertex/utils/functions.dart';

class BuySellPage extends StatefulWidget {
  final bool isGuest;
  final UserEntity? user;
  const BuySellPage({super.key, required this.isGuest, required this.user});

  @override
  State<BuySellPage> createState() => _BuySellPageState();
}

class _BuySellPageState extends State<BuySellPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3));
    BlocProvider.of<BuySellBloc>(context).add(const GetBuySellItemsEvent());
  }

  List<BuySellItemEntity> bnsItems = [];

  Widget priceTagWidget({required String tag}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color:
            tag.contains('Min') ? Colors.green.shade100 : Colors.red.shade100,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        tag,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: tag.contains('Min') ? Colors.green : Colors.red,
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
          title: Text("Buy and Sell",
              style: Theme.of(context).textTheme.bodyMedium),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: BlocBuilder<BuySellBloc, BuySellState>(
            builder: (context, state) {
              if (state is BuySellItemsLoading ||
                  state is BuySellInitial ||
                  state is BuySellItemDeleting) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BuySellItemsLoaded) {
                bnsItems = state.items;
                if (bnsItems.isEmpty) {
                  return Center(
                    child: Text(
                      "No items found",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                bnsItems.sort((first, second) =>
                    second.updatedAt.compareTo(first.updatedAt));
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  primary: true,
                  itemCount: bnsItems.length,
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
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              bnsItems[index].productImage.isNotEmpty
                                  ? CarouselSlider(
                                      items: bnsItems[index]
                                          .productImage
                                          .map((image) => ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(15),
                                                    topRight:
                                                        Radius.circular(15)),
                                                child: CachedNetworkImage(
                                                    imageUrl: image,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            20,
                                                    placeholder:
                                                        (context, url) {
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    },
                                                    errorWidget: (context,
                                                        object, stacktrace) {
                                                      return Icon(
                                                          Icons
                                                              .error_outline_rounded,
                                                          size: 40,
                                                          color: Theme.of(
                                                                  context)
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
                              // bnsItems[index].productImage.isNotEmpty
                              //     ? SizedBox(
                              //         height: MediaQuery.of(context).size.height *
                              //             0.02,
                              //       )
                              //     : Container(),
                              Container(
                                width: MediaQuery.of(context).size.width - 30,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.height *
                                            0.015,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        DateFormat.yMMMMd()
                                            .format(bnsItems[index].updatedAt),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.005),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(bnsItems[index].name,
                                                  textAlign: TextAlign.start,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                              Text(bnsItems[index].phoneNo,
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
                                                  bnsItems[index].phoneNo);
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.005),
                                    ExpandableText(
                                        text:
                                            bnsItems[index].productDescription,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withAlpha(180))),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        priceTagWidget(
                                            tag:
                                                "Min: ${bnsItems[index].minPrice}"),
                                        Icon(Icons.compare_arrows,
                                            size: 30,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(150)),
                                        priceTagWidget(
                                          tag:
                                              "Max: ${bnsItems[index].maxPrice}",
                                        ),
                                      ],
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
                                radius: screenSize.aspectRatio * 40,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withAlpha(100),
                                child: Icon(Icons.more_vert_rounded,
                                    size: screenSize.aspectRatio * 60,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                              color: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withAlpha(100),
                                  width: 1,
                                ),
                              ),
                              onSelected: (value) async {
                                if (widget.isGuest) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'You need to login to edit/delete this item.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                    ),
                                  );
                                  return;
                                }
                                bool canEditDelete = widget.user!.email ==
                                        bnsItems[index].soldBy ||
                                    await isAdmin(widget.user!.email);
                                if (canEditDelete == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "You don't have access to edit/delete this item. Only the owner or admin can do that.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      backgroundColor:
                                          Theme.of(context).cardColor,
                                    ),
                                  );
                                  return;
                                }
                                if (value == 1) {
                                  GoRouter.of(context).pushNamed(
                                      UhlLinkRoutesNames
                                          .buySellAddOrEditItemPage,
                                      extra: {
                                        "user": widget.user,
                                        "isEditing": true,
                                        "bnsItem": bnsItems[index]
                                      });
                                } else if (value == 2) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Delete BnS Item',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium),
                                        content: Text(
                                            'Are you sure you want to delete this BnS item?',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              BlocProvider.of<BuySellBloc>(
                                                      context)
                                                  .add(DeleteBuySellItemEvent(
                                                      id: bnsItems[index].id));
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Delete',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onError,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<int>>[
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Text('Edit',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Text('Delete',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError,
                                          )),
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
              } else if (state is BuySellItemsLoadingError) {
                return const Center(
                    child: Text(
                        'Failed to load BnS items.\n Check your internet connection.',
                        style: TextStyle(color: Colors.red)));
              } else if (state is BuySellItemAddedOrEdited ||
                  state is BuySellItemsAddingOrEditingError ||
                  state is BuySellItemDeletedSuccessfully ||
                  state is BuySellItemDeleteError) {
                BlocProvider.of<BuySellBloc>(context)
                    .add(const GetBuySellItemsEvent());
                return CircularProgressIndicator();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        floatingActionButton: (!widget.isGuest && widget.user != null)
            ? GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                      UhlLinkRoutesNames.buySellAddOrEditItemPage,
                      extra: {
                        "user": widget.user,
                        "isEditing": false,
                        "bnfItem": null
                      });
                },
                child: CircleAvatar(
                  radius: screenSize.aspectRatio * 60,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(Icons.add_rounded,
                      size: screenSize.aspectRatio * 90,
                      color: Theme.of(context).colorScheme.onPrimary),
                ))
            : Container());
  }
}
