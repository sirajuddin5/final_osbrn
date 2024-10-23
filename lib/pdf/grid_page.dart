import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfGridView extends StatelessWidget {
  final PdfViewerController pdfViewerController;

  PdfGridView({required this.pdfViewerController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Grid View'),
        backgroundColor: Colors.deepPurple,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: pdfViewerController.pageCount,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              pdfViewerController.jumpToPage(index + 1);
              Navigator.pop(context);
            },
            child: Card(
              elevation: 3,
              child: Column(
                children: [
                  Expanded(
                    child: SfPdfViewer.asset(
                      'asset/12.pdf',
                      controller: PdfViewerController(),
                      pageLayoutMode: PdfPageLayoutMode.single,
                      canShowScrollStatus: false,
                      initialPageNumber: index + 1,
                      canShowPaginationDialog: false,
                      enableDoubleTapZooming: false,
                      enableTextSelection: false,
                      interactionMode: PdfInteractionMode.selection,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Page ${index + 1}'),
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