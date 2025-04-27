import 'dart:ui';

import 'package:osborn_book/pdf/service/hive_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

void updateLocalAnnotations(String urlId, PdfViewerController pdfViewerController) {
  final notes = HiveService.getNotesForPdf(urlId);
  final highlights = HiveService.getHighlightsForPdf(urlId);

  for (final note in notes) {
    pdfViewerController.addAnnotation(
      StickyNoteAnnotation(
        pageNumber: note.page,
        text: note.text,
        position: Offset(note.x, note.y),
        icon: PdfStickyNoteIcon.note,
      ),
    );
  }
  for (final highlight in highlights) {
    List<PdfTextLine> textBounds = [];
    for (final line in highlight.pdfTextLines) {
      textBounds.add(PdfTextLine(
          Rect.fromLTWH(line.x, line.y, line.width, line.height),
          line.text,
          line.pageNumber));
    }
    pdfViewerController.addAnnotation(
      HighlightAnnotation(
        textBoundsCollection: textBounds,
      ),
    );
  }
}
