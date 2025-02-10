import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:uhl_link/config/routes/routes_consts.dart';
import 'package:uhl_link/features/home/presentation/widgets/dashboard_card.dart';

class Dashboard extends StatefulWidget {
  final bool isGuest;
  final Map<String, dynamic>? user;

  const Dashboard({super.key, required this.isGuest, required this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

int currentImage = 0;

final List<String> carouselImages = [
  'https://www.iitmandi.ac.in/images/slider/slider5.jpg',
  'https://www.iitmandi.ac.in/images/slider/slider5.jpg',
  'https://www.iitmandi.ac.in/images/slider/slider5.jpg',
  'https://www.iitmandi.ac.in/images/slider/slider5.jpg',
  'https://www.iitmandi.ac.in/images/slider/slider5.jpg',
];

class _DashboardState extends State<Dashboard> {
  Widget carouselIndicatorWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < carouselImages.length; i++)
          Container(
            margin: const EdgeInsets.all(10),
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: i == currentImage
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.scrim,
              shape: BoxShape.circle,
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "title": 'Lost/Found',
        "icon": Icons.card_travel,
        'path': UhlLinkRoutesNames.lostFoundPage,
        'pathParameters': {
          "isGuest": jsonEncode(widget.isGuest),
          "user": jsonEncode(widget.user)
        }
      },
      {
        "title": 'Buy/Sell',
        "icon": Icons.shopping_cart_outlined,
        "path": UhlLinkRoutesNames.test,
        'pathParameters': {}
      },
      {
        "title": 'Maps',
        "icon": Icons.map_outlined,
        "path": UhlLinkRoutesNames.campusMapPage,
        'pathParameters': {}
      },
      {
        "title": 'Calendar',
        "icon": Icons.calendar_today_outlined,
        "path": UhlLinkRoutesNames.academicCalenderPage,
        'pathParameters': {}
      },
      {
        "title": 'Events',
        "icon": Icons.menu,
        "path": UhlLinkRoutesNames.test,
        'pathParameters': {}
      },
      {
        "title": 'Mess Menu',
        "icon": Icons.restaurant,
        "path": UhlLinkRoutesNames.messMenuPage,
        'pathParameters': {}
      },
    ];
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      reverse: true,
      primary: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
              items: carouselImages
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
                          child: CachedNetworkImage(
                              imageUrl: image, fit: BoxFit.cover),
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                  height: screenSize.height * 0.3,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  autoPlayInterval: const Duration(seconds: 5),
                  enlargeCenterPage: true,
                  onPageChanged: (value, _) {
                    setState(() {
                      currentImage = value;
                    });
                  })),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          carouselIndicatorWidget(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            "Explore",
            style:
                Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 23),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.28,
            child: GridView.count(
              crossAxisCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              children: [
                for (int i = 0; i < items.length; i++)
                  DashboardCard(
                    title: items[i]['title'],
                    icon: items[i]['icon'],
                    onTap: () {
                      if (items[i]['pathParameters'] != null &&
                          items[i]['pathParameters'].isNotEmpty) {
                        GoRouter.of(context).pushNamed(
                          items[i]['path'],
                          pathParameters: items[i]['pathParameters'],
                        );
                      } else {
                        GoRouter.of(context).pushNamed(items[i]['path']);
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
