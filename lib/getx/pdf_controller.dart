import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:osborn_book/pdf/models/highlights.dart';
import 'package:osborn_book/pdf/models/notes.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfController extends GetxController {
  RxMap<String, RxList<Highlight>> highlightsMap = <String, RxList<Highlight>>{}.obs;
  RxMap<String, RxList<Note>> notesMap = <String, RxList<Note>>{}.obs;

  RxBool isInit = false.obs;
  RxBool isDocLoaded = false.obs;

  PdfViewerController? _pdfViewerController;

  PdfController();

  void init(String urlId ,PdfViewerController pdfViewerController, List<Highlight> highlights, List<Note> notes) {
    _pdfViewerController = pdfViewerController;
    highlightsMap.clear();
    notesMap.clear();
    highlightsMap[urlId] = highlights.obs;
    notesMap[urlId] = notes.obs;
    updateAnnotations(urlId);
  }

  void updateAnnotations(String urlId) {
    log("Annotations update called");
    final highlights = highlightsMap[urlId] ?? [];
    final notes = notesMap[urlId] ?? [];
    for (final highlight in highlights) {
      List<PdfTextLine> list = [];

      for (final line in highlight.pdfTextLines) {
        list.add(PdfTextLine(
            Rect.fromLTWH(line['x'], line['y'], line['width'], line['height']),
            line['text'],
            line['pageNumber']));
      }

      _pdfViewerController?.addAnnotation(
        HighlightAnnotation(
          textBoundsCollection: list,
        ),
      );
    }
    for (final note in notes) {
      _pdfViewerController?.addAnnotation(
        StickyNoteAnnotation(
          pageNumber: note.page,
          text: note.text,
          position: Offset(note.x, note.y),
          icon: PdfStickyNoteIcon.note,
        ),
      );
    }
  }

  void addNote(String urlId, Note note) {
    notesMap[urlId]?.add(note);
    _pdfViewerController?.removeAllAnnotations();
    updateAnnotations(urlId);
  }

  void removeNote(String urlId, Note note) {
    log("Note removed: ${note.id}");
    notesMap[urlId]?.removeWhere((n) => n.id == note.id);
    _pdfViewerController?.removeAllAnnotations();
    updateAnnotations(urlId);
  }

  void updateNote(String urlId, Note note) {
    log("Note updated: ${note.id}");
    final index = notesMap[urlId]?.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      if (index != null) {
        notesMap[urlId]?[index] = note;
      }
      _pdfViewerController?.removeAllAnnotations();
      updateAnnotations(urlId);
    }
  }

  void addHighlight(String urlId, Highlight highlight) {
    log("Highlight added: ${highlight.id}");
    highlightsMap[urlId]?.add(highlight);
  }

  void removeHighlight(String urlId, Highlight highlight) {
    log("Highlight removed: ${highlight.id}");
    highlightsMap[urlId]?.removeWhere((h) => h.id == highlight.id);
    _pdfViewerController?.removeAllAnnotations();
    updateAnnotations(urlId);
  }

  void clearData() {
    highlightsMap.clear();
    notesMap.clear();
  }
}
