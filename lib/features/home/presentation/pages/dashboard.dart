import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
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

final List<String> carouselImages = [];

class _DashboardState extends State<Dashboard> {
  List<String> carouselImages = []; // Initially empty
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      // GitHub API endpoint for the directory contents
      const String apiUrl =
          'https://api.github.com/repos/Aman071106/IITApp/contents/other_resources/dashboard_images';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> files = jsonDecode(response.body);

        // Filter for image files and construct raw URLs
        List<String> imageUrls = files
            .where((file) =>
                file['type'] == 'file' &&
                (file['name'].endsWith('.jpg') ||
                    file['name'].endsWith('.png') ||
                    file['name'].endsWith('.jpeg')))
            .map((file) =>
                'https://raw.githubusercontent.com/Aman071106/IITApp/main/other_resources/dashboard_images/${file['name']}')
            .toList();

        setState(() {
          carouselImages = imageUrls;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      log('Error fetching images: $e');
      setState(() {
        isLoading = false;
      });
      // Fallback to a default image or handle error
      carouselImages = [
        'https://via.placeholder.com/150' // Fallback image
      ];
    }
  }

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
      {
        "title": 'Cafeteria',
        "icon": Icons.local_cafe,
        "path": UhlLinkRoutesNames.cafeteria,
        'pathParameters': {}
      },
    ];
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
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
          GridView.count(
            crossAxisCount: 3,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            shrinkWrap: true,
            primary: false,
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
        ],
      ),
    );
  }
}
