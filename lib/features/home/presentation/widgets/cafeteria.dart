import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafeteria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CafeteriaPage(),
    );
  }
}

class CafeteriaPage extends StatefulWidget {
  const CafeteriaPage({super.key});

  @override
  _CafeteriaPageState createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true; // To show loading indicator

  @override
  void initState() {
    super.initState();
    loadCafeteriaData();
  }

  Future<void> loadCafeteriaData() async {
    try {
      String response = await rootBundle.loadString('assets/cafeteria.json');
      Map<String, dynamic> data = json.decode(response);

      if (data.containsKey("items")) {
        setState(() {
          items = List<Map<String, dynamic>>.from(data["items"]);
          isLoading = false;
        });
      } else {
        throw Exception("Invalid JSON format: 'items' key not found");
      }
    } catch (e) {
      debugPrint("Error loading JSON: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cafeteria')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader
          : ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item['images'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: ImageSlider(images: List<String>.from(item['images'])),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'] ?? "Unknown",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text("Time: ${item['time'] ?? 'N/A'}"),
                        Text("Contact: ${item['contact'] ?? 'N/A'}"),
                        Text("Location: ${item['location'] ?? 'N/A'}"),
                        Text("Delivery Time: ${item['deliveryTime'] ?? 'N/A'}"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (item['menu'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuPage(item['name'], List<String>.from(item['menu'])),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        "View Menu",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageSlider extends StatelessWidget {
  final List<String> images;

  const ImageSlider({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              images[index],
              width: double.infinity,
              height: 177,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, size: 50));
              },
            ),
          );
        },
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  final String cafeteriaName;
  final List<String> menuImages;

  const MenuPage(this.cafeteriaName, this.menuImages, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$cafeteriaName Menu")),
      body: PhotoViewGallery.builder(backgroundDecoration:BoxDecoration(color: Color.fromRGBO(255,253,208,0.1)) ,
        itemCount: menuImages.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(menuImages[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
      ),
    );
  }
}
