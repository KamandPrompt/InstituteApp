import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/domain/entities/buy_sell_item_entity.dart';
import 'package:uhl_link/features/home/presentation/bloc/buy_sell_bloc/bns_bloc.dart';

class BuySellPage extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;
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

  // Widget bnsTagWidget({required String tag}) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  //     decoration: BoxDecoration(
  //       color: tag == 'Found' ? Colors.green : Colors.red,
  //       borderRadius: BorderRadius.circular(10.0),
  //     ),
  //     child: Text(
  //       tag,
  //       overflow: TextOverflow.ellipsis,
  //       maxLines: 1,
  //       style: Theme.of(context)
  //           .textTheme
  //           .labelSmall
  //           ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
  //     ),
  //   );
  // }

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: BlocBuilder<BuySellBloc,BuySellState>(
            builder: (context, state) {
              if (state is BuySellItemsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BuySellItemsLoaded) {
                bnsItems = state.items;
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  primary: false,
                  itemCount: bnsItems.length,
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
                                    items: bnsItems[index]
                                        .productImage
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
                                                child: Image.file(File(image),
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
                                // Image.network(
                                //   items[index]["image"]!,
                                //   height: MediaQuery.of(context).size.height * 0.25,
                                //   fit: BoxFit.cover,
                                // ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ProductName : ${bnsItems[index].productName}",
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text("Contact : ${bnsItems[index].phoneNo}",
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text("Date : ${bnsItems[index].addDate.toLocal()}",
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text(
                                      "Description : ${bnsItems[index].productDescription}",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text(
                                      "MaxPrice : ${bnsItems[index].maxPrice}",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01),
                                    Text(
                                      "MinPrice : ${bnsItems[index].minPrice}",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                );
              } else if (state is BuySellItemsLoadingError) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        floatingActionButton: widget.isGuest
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(
                        UhlLinkRoutesNames.buySellAddItemPage,
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