import 'dart:convert'; // Importing necessary libraries for JSON parsing

import 'package:flutter/material.dart'; // Importing Flutter material design package
import 'package:flutter/services.dart'; // Importing services package for asset loading
import 'package:simple_animations/simple_animations.dart'; // Importing simple animations package for smooth transitions
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import for page indicators

// Widget for creating a fade animation effect
class FadeAnimation extends StatelessWidget {
  final double delay; // Delay for the animation
  final Widget child; // Widget to apply the animation on

  const FadeAnimation(
      {super.key,
        required this.delay,
        required this.child}); // Constructor for the widget

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween() // Creating an animation sequence
      ..tween('opacity', Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500)) // Fade In effect
      ..tween('translateY', Tween(begin: 120.0, end: 0.0),
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut); // Slide Up effect

    return PlayAnimationBuilder<Movie>(
      // Building the animation with a delay
      delay: Duration(milliseconds: (50 * delay).round()),
      duration: tween.duration, // Duration of the animation
      tween: tween, // The tween animation sequence
      child: child, // The widget to apply animation
      builder: (context, animation, child) => Opacity(
        // Using opacity and translation for the animation effect
        opacity: animation.get('opacity'),
        child: Transform.translate(
          offset: Offset(
              0, animation.get('translateY')), // Translate the widget upwards
          child: child, // The widget to be animated
        ),
      ),
    );
  }
}

// Cafeteria screen widget
class Cafeteria extends StatefulWidget {
  const Cafeteria({super.key}); // Constructor for the Cafeteria widget

  @override
  createState() => _CafeteriaState(); // State creation for the Cafeteria widget
}

class _CafeteriaState extends State<Cafeteria> {
  List<Map<String, dynamic>> cafeterias = []; // List to hold cafeteria data
  //require changes
  final List<String> cafeImages = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUwmVgb3neqeHNKLlGiWbtp3Twk9SNoc2y4A&s",
    "https://www.hindustantimes.com/ht-img/img/2024/09/07/550x309/The-romantic-visitor-is-more-interesting-to-the-ca_1725739263282.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgaWLWxO01zoJh2aohremhWRsksyuEYiBFqQ&s",
    "https://i.pinimg.com/736x/28/df/25/28df25e025dc6dc4eed109fa81bada4d.jpg"
  ]; // Constant cafe images

  @override
  void initState() {
    super.initState();
    readJson(); // Load JSON data when the widget is initialized
  }

  // Method to load and parse the JSON data
  Future<void> readJson() async {
    try {
      // Load JSON file from assets
      String response = await rootBundle.loadString('assets/cafeteria.json');
      Map<String, dynamic> data = json.decode(response); // Parse the JSON

      // Ensure JSON structure is correct
      if (data.containsKey("cafeterias")) {
        setState(() {
          cafeterias = List<Map<String, dynamic>>.from(data["cafeterias"]);
        });
      }
    } catch (e) {
      print("Error loading JSON: $e"); // Error handling for JSON loading
    }
  }

  int _show = -1; // To manage selected cafeteria index for menu display
  String _searched = ""; // To hold the searched cafeteria name
  bool _imageLoading = true; // To manage image loading state

  @override
  Widget build(BuildContext context) {
    var screenSize =
    MediaQuery.sizeOf(context); // Get screen size for responsive UI
    List<Map<String, dynamic>> filteredCafeterias = cafeterias
        .where((cafe) => cafe["name"]!.toLowerCase().contains(
        _searched.toLowerCase())) // Filter cafeterias based on search input
        .toList();

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white, // Set background color
          appBar: AppBar(
            backgroundColor: Colors.white30, // Customize app bar
            title: const Text(
              "Cafeterias",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold), // Set app bar title
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(6)), // Styling search container
                    border: Border.all(width: 0.3, color: Colors.black),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searched = value; // Update search query
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ), // Search icon
                      hintText: "Search Cafeteria", // Search placeholder text
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ),
              if (filteredCafeterias
                  .isNotEmpty) // Check if filtered cafeterias exist
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCafeterias.length,
                    itemBuilder: (context, index) {
                      final cafe = filteredCafeterias[index];
                      PageController pageController = PageController();
                      return FadeAnimation(
                        delay:
                        0.5 * index, // Apply animation delay based on index
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8), // Style the card container
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.4),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.withValues(alpha: 0.1),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 8,
                            shadowColor: Colors.black12.withValues(alpha: 0.01),
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.black)),
                                    height: 200,
                                    child: PageView.builder(
                                      controller: pageController,
                                      itemCount: cafeImages.length,
                                      itemBuilder: (context, imgIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(2),
                                            child: Image.network(
                                              cafeImages[imgIndex],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Dot Indicator
                                  Center(
                                    child: SmoothPageIndicator(
                                      controller: pageController,
                                      count: cafeImages.length,
                                      effect: ExpandingDotsEffect(
                                        dotHeight: 8,
                                        dotWidth: 8,
                                        activeDotColor: Colors.blueAccent,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    cafe["name"]!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(" Time:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18)),
                                          Text(" ${cafe["openingTime"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 17)),
                                        ],
                                      ), // Opening time text
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(" Delivery:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18)),
                                      Text(" ${cafe["deliveryTime"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                              17)), // Delivery time text
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(" Contact:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18)),
                                      Text(cafe["contact"]!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize:
                                              17)), // Contact number text
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(" Location:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18)),
                                      Expanded(
                                        child: Text(cafe["location"]!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 17)), // Location text
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _show =
                                              index; // Set the index to show menu
                                          _imageLoading =
                                          true; // Reset loading state
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 16,
                                            right: 16),
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                      ),
                                      child: const Text(
                                        "View Menu",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white), // Button text
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "No Cafeteria Found",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.bold), // Message when no cafeteria found
                  ),
                ),
            ],
          ),
        ),
        if (_show != -1) // Check if a cafeteria's menu is to be shown
          Container(
            color: Colors.black.withOpacity(0.8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InteractiveViewer(
                    panEnabled: true,
                    panAxis: PanAxis.free,
                    child: PageView.builder(
                      itemCount: cafeterias[_show]["menuImages"]
                          .length, // Show the menu images
                      itemBuilder: (context, imgIndex) {
                        return Center(
                          child: Image.network(
                            cafeterias[_show]["menuImages"]
                            [imgIndex], // Show image from the menu
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        backgroundColor:
                        Colors.redAccent[200] // Close button style
                    ),
                    onPressed: () {
                      setState(() {
                        _show = -1; // Close the menu view
                      });
                    },
                    child: Container(
                      width: screenSize.width / 4, // Set close button width
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.white,
                          ), // Close icon
                          SizedBox(
                            width: 6,
                          ),
                          const Text(
                            "Close",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ), // Close text
                        ],
                      ),
                    )),
              ],
            ),
          )
      ],
    );
  }
}