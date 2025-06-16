import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:vertex/features/home/presentation/widgets/card.dart';
import 'package:vertex/utils/functions.dart';

class CampusMapPage extends StatefulWidget {
  const CampusMapPage({super.key});

  @override
  State<CampusMapPage> createState() => _CampusMapPageState();
}

class _CampusMapPageState extends State<CampusMapPage> {
  bool isNorthMap = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Campus Map",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "3D Campus Map",
            icon: Icon(Icons.threed_rotation_rounded,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              launchURL("https://maps.iitmandi.co.in/");
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 1.5,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.only(bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: PDF(
                    backgroundColor: Theme.of(context).cardColor,
                  ).cachedFromUrl(
                    isNorthMap
                        ? 'https://infra.iitmandi.ac.in/pdf/north.pdf'
                        : 'https://infra.iitmandi.ac.in/pdf/south.pdf',
                    key: ValueKey(isNorthMap),
                    placeholder: (double progress) => Center(
                      child: CircularProgressIndicator(
                        value: progress / 100,
                        strokeWidth: 3,
                      ),
                    ),
                    errorWidget: (error) => Center(
                      child: Text(
                        "Failed to load map.\nPlease check your internet connection.",
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: Theme.of(context).colorScheme.scrim),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CardWidget(
              text: "North Campus",
              icon: Icons.north_rounded,
              onTap: () {
                setState(() {
                  isNorthMap = true;
                });
              },
              isTrue: isNorthMap,
            ),
            CardWidget(
              text: "South Campus",
              icon: Icons.south_rounded,
              onTap: () {
                setState(() {
                  isNorthMap = false;
                });
              },
              isTrue: !isNorthMap,
            ),
          ],
        ),
      ),
    );
  }
}
