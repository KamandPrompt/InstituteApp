import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/domain/entities/lost_found_item_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/lost_found_bloc/lnf_bloc.dart';

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
    BlocProvider.of<LnfBloc>(context).add(const GetLostFoundItemsEvent());
  }

  List<LostFoundItemEntity> lnfItems = [];

  Widget lnfTagWidget({required String tag}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: tag == 'Found' ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        tag,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: BlocBuilder<LnfBloc, LnfState>(
            builder: (context, state) {
              if (state is LnfItemsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LnfItemsLoaded) {
                lnfItems = state.items;
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
                                    items: lnfItems[index]
                                        .images
                                        .map((image) => ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                      color: Theme.of(context)
                                                          .cardColor
                                                          .withValues(
                                                              alpha: 0.2),
                                                      width: 1.5,
                                                    )),
                                                child: Image.network(image,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25, errorBuilder:
                                                        (context, object,
                                                            stacktrace) {
                                                  return Icon(
                                                      Icons
                                                          .error_outline_rounded,
                                                      size: 40,
                                                      color: Theme.of(context)
                                                          .primaryColor);
                                                }, fit: BoxFit.cover),
                                              ),
                                            ))
                                        .toList(),
                                    options: CarouselOptions(
                                        height: screenSize.height * 0.3,
                                        autoPlay: true,
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 1,
                                        autoPlayInterval:
                                            const Duration(seconds: 5),
                                        enlargeCenterPage: true)),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Name : ${lnfItems[index].name}",
                                          textAlign: TextAlign.start,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      Text(
                                          "Contact : ${lnfItems[index].phoneNo}",
                                          textAlign: TextAlign.start,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      Text(
                                          "Date : ${lnfItems[index].date.toLocal()}",
                                          textAlign: TextAlign.start,
                                          softWrap: true,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      Text(
                                        "Description : ${lnfItems[index].description}",
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                                top: 8,
                                right: 8,
                                child: lnfTagWidget(
                                    tag: lnfItems[index].lostOrFound))
                          ],
                        ),
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
