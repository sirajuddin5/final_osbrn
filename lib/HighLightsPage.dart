import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/app_state.dart';
import 'package:osborn_book/pdf/service/highlight_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HighlightsPage extends StatefulWidget {
  final String? urlId;
  const HighlightsPage(
      {Key? key, required this.urlId, required this.pdfViewerController})
      : super(key: key);
  final PdfViewerController? pdfViewerController;

  @override
  State<HighlightsPage> createState() => _HighlightsPageState();
}

class _HighlightsPageState extends State<HighlightsPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final highlights = appState.highlights;
    final high = HighlightService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Highlights'),
      ),
      body: FutureBuilder(
          future: high.getHighlights(widget.urlId!),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return const Center(
                  child: Text('No hightlights found or something went wrong'));
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
                      widget.pdfViewerController!
                          .jumpToPage(highlight.pdfTextLines[0]['pageNumber']);

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
