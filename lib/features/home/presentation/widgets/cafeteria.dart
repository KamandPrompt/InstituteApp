import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vertex/utils/constants.dart';

class CafeteriaPage extends StatefulWidget {
  const CafeteriaPage({super.key});

  @override
  State<CafeteriaPage> createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage> {
  List<Map<String, dynamic>> items = Constants.cafeteria["cafes"];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Cafeteria",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          List<String> images =
              (item["images"] as List<dynamic>).cast<String>();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images
                            .map((image) => Container(
                                  width: screenSize.width - 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .cardColor,
                                      width: 1.5,
                                    ),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: image.toString(),
                                      fit: BoxFit.cover,
                                      errorWidget: (context, string, object) {
                                        return Text(
                                          "Error loading image.",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .scrim),
                                        );
                                      },
                                    ),
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                            height: screenSize.height * 0.25,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            autoPlayInterval: const Duration(seconds: 15),
                            enlargeCenterPage: true))
                    : Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(item['name'].toString(),
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 5),
                    Text("Time: ${item['time'] ?? 'N/A'}",
                        style: Theme.of(context).textTheme.labelSmall),
                    Text("Contact: ${item['contact'] ?? 'N/A'}",
                        style: Theme.of(context).textTheme.labelSmall),
                    Text("Location: ${item['location'] ?? 'N/A'}",
                        style: Theme.of(context).textTheme.labelSmall),
                    Text("Delivery Time: ${item['deliveryTime'] ?? 'N/A'}",
                        style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    List<String> menu =
                        (item["menu"] as List<dynamic>).cast<String>();
                    if (menu.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: CarouselSlider(
                                items: menu
                                    .map((image) => CachedNetworkImage(
                                          imageUrl: image.toString(),
                                          fit: BoxFit.cover,
                                          errorWidget:
                                              (context, string, object) {
                                            return Text(
                                              "Error loading menu.",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .scrim),
                                            );
                                          },
                                          placeholder: (context, url) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                  height: screenSize.height * 0.5,
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  autoPlayInterval: const Duration(seconds: 15),
                                )),
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Menu not availabe.",
                              style: Theme.of(context).textTheme.labelSmall),
                          backgroundColor: Theme.of(context).cardColor.withAlpha(150)));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("View Menu",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.02,
          );
        },
      ),
    );
  }
}
