import 'dart:convert';
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
    Future.delayed(const Duration(seconds: 3));
    BlocProvider.of<LnfBloc>(context).add(const GetLostFoundItemsEvent());
  }

  List<LostFoundItemEntity> lnfItems = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: BlocBuilder<LnfBloc, LnfState>(
            builder: (context, state) {
              if (state is LnfItemsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is LnfItemsLoaded) {
                lnfItems = state.items;
                return ListView.separated(
                  physics: const ClampingScrollPhysics(),
                  primary: false,
                  itemCount: lnfItems.length,
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
                              crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the start
                              children: [
                                CarouselSlider(
                                  items: lnfItems[index]
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
                                          height: MediaQuery.of(context).size.height * 0.25,
                                          errorBuilder: (context, object, stacktrace) {
                                            return Icon(Icons.error_outline_rounded,
                                                size: 40,
                                                color: Theme.of(context).primaryColor);
                                          },
                                          fit: BoxFit.cover),
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
                                  crossAxisAlignment: CrossAxisAlignment.start, // Ensures text aligns to the left
                                  children: [
                                    Text("Freshers Contest 2.0", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                    Text('By: Kamand Prompt', style: const TextStyle(fontSize: 14 ,color: Colors.black45)),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                                    Text(
                                      "Freshers Contest 2.0 is a 2-hour competitive programming contest hosted by KamandPrompt on Codeforces, exclusively designed for first-year students at IIT Mandi. This event is a fantastic opportunity for freshers to test their problem-solving skills, enhance their algorithmic thinking, and experience the thrill of competitive programming."
                                          .substring(0, 60)+"...",
                                      textAlign: TextAlign.start,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01), // Space between text and View More
                                    GestureDetector(
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

                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 20,
                    );
                  },
                );
              } else if (state is LnfItemsLoadingError) {
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
                  UhlLinkRoutesNames.feedAddItemPage,
                  pathParameters: {"user": jsonEncode(widget.user)});
            },
            label: Text('Add Events',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 16)),
            icon: Icon(Icons.add_box_rounded,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        ));
  }
}
