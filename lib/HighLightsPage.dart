import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:osborn_book/getx/pdf_controller.dart';
import 'package:osborn_book/pdf/app_state.dart';
import 'package:osborn_book/pdf/models/local_highlight.dart';
import 'package:osborn_book/pdf/service/highlight_service.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
import 'package:osborn_book/pdf/utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HighlightsPage extends StatefulWidget {
  final String? urlId;
  const HighlightsPage(
      {super.key,
      required this.urlId,
      required this.pdfViewerController,
      this.isLocal = false});
  final PdfViewerController? pdfViewerController;

  final bool? isLocal;

  @override
  State<HighlightsPage> createState() => _HighlightsPageState();
}

class _HighlightsPageState extends State<HighlightsPage> {
  RxList<LocalHighlight>? localList;

  @override
  void initState() {
    localList = widget.isLocal!
        ? HiveService.getHighlightsForPdf(widget.urlId.toString()).obs
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final high = HighlightService();
    final pdfController = Get.find<PdfController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlights'),
      ),
      body: widget.isLocal!
          ? Obx(
              () => localList != null && localList!.isNotEmpty
                  ? ListView.builder(
                      itemCount: localList!.length,
                      itemBuilder: (context, index) {
                        final highlight = localList![index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(
                              highlight.pdfTextLines.first.text,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Page: ${highlight.pdfTextLines.first.pageNumber}'),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.yellowAccent,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Text(
                                      'Position: (${highlight.pdfTextLines.first.x.toStringAsFixed(1)}, ${highlight.pdfTextLines.first.y.toStringAsFixed(1)})',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Size: ${highlight.pdfTextLines.first.width.toStringAsFixed(1)} × ${highlight.pdfTextLines.first.height.toStringAsFixed(1)}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () async {
                                await HiveService.deleteHighlight(
                                    widget.urlId!, highlight.id);
                                localList?.removeWhere(
                                    (element) => element.id == highlight.id);
                                widget.pdfViewerController
                                    ?.removeAllAnnotations();
                                updateLocalAnnotations(
                                    widget.urlId!, widget.pdfViewerController!);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            onTap: () {
                              widget.pdfViewerController?.jumpToPage(
                                  highlight.pdfTextLines.first.pageNumber);

                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No highlights found'),
                    ),
            )
          : NetworkList(
              pdfController: pdfController, high: high, widget: widget, urlId: widget.urlId!),
    );
  }
}

class LocalList extends StatelessWidget {
  const LocalList({
    super.key,
    required this.localList,
    required this.widget,
  });

  final RxList<LocalHighlight>? localList;
  final HighlightsPage widget;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => localList != null && localList!.isNotEmpty
          ? ListView.builder(
              itemCount: localList!.length,
              itemBuilder: (context, index) {
                final highlight = localList![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      highlight.pdfTextLines.first.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Page: ${highlight.pdfTextLines.first.pageNumber}'),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Text(
                              'Position: (${highlight.pdfTextLines.first.x.toStringAsFixed(1)}, ${highlight.pdfTextLines.first.y.toStringAsFixed(1)})',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          'Size: ${highlight.pdfTextLines.first.width.toStringAsFixed(1)} × ${highlight.pdfTextLines.first.height.toStringAsFixed(1)}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: () async {
                        await HiveService.deleteHighlight(
                            widget.urlId!, highlight.id);
                        widget.pdfViewerController?.removeAllAnnotations();
                        updateLocalAnnotations(
                            widget.urlId!, widget.pdfViewerController!);
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      widget.pdfViewerController
                          ?.jumpToPage(highlight.pdfTextLines.first.pageNumber);

                      Navigator.pop(context);
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text('No highlights found'),
            ),
    );
  }
}

class NetworkList extends StatelessWidget {
  const NetworkList({
    super.key,
    required this.pdfController,
    required this.high,
    required this.widget,
    required this.urlId,
  });

  final PdfController pdfController;
  final HighlightService high;
  final HighlightsPage widget;
  final String urlId;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (pdfController.highlightsMap[urlId] ?? []).isNotEmpty
        ? ListView.builder(
            itemCount: (pdfController.highlightsMap[urlId] ?? []).length,
            itemBuilder: (context, index) {
              final highlight = (pdfController.highlightsMap[urlId] ?? [])[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    highlight.pdfTextLines[0]['text'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Page: ${highlight.pdfTextLines[0]['pageNumber']}'),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Text(
                            'Position: (${highlight.pdfTextLines[0]['x'].toStringAsFixed(1)}, ${highlight.pdfTextLines[0]['y'].toStringAsFixed(1)})',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        'Size: ${highlight.pdfTextLines[0]['width'].toStringAsFixed(1)} × ${highlight.pdfTextLines[0]['height'].toStringAsFixed(1)}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: InkWell(
                    onTap: () async {
                      try {
                        await high.deleteHighlight(highlight.id);
                        pdfController.removeHighlight(urlId, highlight);
                      } catch (e) {
                        log("Error deleting highlight: $e");
                      }
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  onTap: () {
                    widget.pdfViewerController!
                        .jumpToPage(highlight.pdfTextLines[0]['pageNumber']);

                    Navigator.pop(context);
                  },
                ),
              );
            },
          )
        : const Center(
            child: Text('No highlights found'),
          ));
  }
}
