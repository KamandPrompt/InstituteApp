import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uhl_link/features/home/presentation/widgets/card.dart';

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
                  child: SfPdfViewerTheme(
                    data: SfPdfViewerThemeData(
                        backgroundColor: Theme.of(context).cardColor),
                    child: SfPdfViewer.network(
                      isNorthMap
                          ? 'https://infra.iitmandi.ac.in/pdf/north.pdf'
                          : 'https://infra.iitmandi.ac.in/pdf/south.pdf',
                      enableTextSelection: false,
                      canShowPaginationDialog: false,
                      canShowTextSelectionMenu: false,
                      canShowHyperlinkDialog: false,
                      interactionMode: PdfInteractionMode.pan,
                      canShowSignaturePadDialog: false,
                      canShowScrollHead: false,
                      maxZoomLevel: 4,
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
