import 'dart:developer';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:osborn_book/pdf/models/highlights.dart';
import 'package:osborn_book/pdf/models/notes.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfController extends GetxController {
  RxList<Highlight> highlights = <Highlight>[].obs;
  RxList<Note> notes = <Note>[].obs;

  RxBool isInit = false.obs;
  RxBool isDocLoaded = false.obs;

  PdfViewerController? _pdfViewerController;

  PdfController();

  void init(PdfViewerController pdfViewerController, List<Highlight> highlights, List<Note> notes) {
    _pdfViewerController = pdfViewerController;
    this.highlights.addAll(highlights);
    this.notes.addAll(notes);
    updateAnnotations();
  }

  void updateAnnotations() {
    log("Annotations update called");
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

  void addNote(Note note) {
    notes.add(note);
    _pdfViewerController?.removeAllAnnotations();
    updateAnnotations();
  }

  void removeNote(Note note) {
    log("Note removed: ${note.id}");
    notes.removeWhere((n) => n.id == note.id);
    _pdfViewerController?.removeAllAnnotations();
    updateAnnotations();
  }

  void updateNote(Note note) {
    log("Note updated: ${note.id}");
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      notes[index] = note;
      _pdfViewerController?.removeAllAnnotations();
      updateAnnotations();
    }
  }

  void addHighlight(Highlight highlight) {
    log("Highlight added: ${highlight.id}");
    highlights.add(highlight);
  }

  void removeHighlight(Highlight highlight) {
    log("Highlight removed: ${highlight.id}");
    highlights.removeWhere((h) => h.id == highlight.id);
    _pdfViewerController?.removeAllAnnotations();
    updateAnnotations();
  }

}
