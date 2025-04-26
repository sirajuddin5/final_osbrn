import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/app_state.dart';
import 'package:osborn_book/pdf/models/local_highlight.dart';
import 'package:osborn_book/pdf/service/highlight_service.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
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
  List<LocalHighlight>? localList;

  @override
  void initState() {
    localList = widget.isLocal!
        ? HiveService.getHighlightsForPdf(widget.urlId.toString())
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final high = HighlightService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Highlights'),
      ),
      body: widget.isLocal!
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
                        await high.deleteHighlight(highlight.id);
                        setState(() {});
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      widget.pdfViewerController!
                          .jumpToPage(highlight.pdfTextLines.first.pageNumber);

                      Navigator.pop(context);
                    },
                  ),
                );
              },
            )
          : FutureBuilder(
              future: high.getHighlights(widget.urlId!),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return const Center(
                      child:
                          Text('No hightlights found or something went wrong'));
                }
                final highlights = snap.data?.data ?? [];

                if (highlights.isEmpty) {
                  return const Center(child: Text('No highlights found'));
                }

                return ListView.builder(
                  itemCount: highlights.length,
                  itemBuilder: (context, index) {
                    final highlight = highlights[index];
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
                            Text(
                                'Page: ${highlight.pdfTextLines[0]['pageNumber']}'),
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
                            await high.deleteHighlight(highlight.id);
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          widget.pdfViewerController!.jumpToPage(
                              highlight.pdfTextLines[0]['pageNumber']);

                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              }),
    );
  }
}
