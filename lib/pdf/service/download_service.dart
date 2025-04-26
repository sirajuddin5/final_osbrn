import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:osborn_book/pdf/models/bookmarks.dart';
import 'package:osborn_book/pdf/models/downloaded_pdf.dart';
import 'package:osborn_book/pdf/models/highlights.dart';
import 'package:osborn_book/pdf/models/notes.dart';
import 'package:osborn_book/pdf/service/bookmark_service.dart';
import 'package:osborn_book/pdf/service/highlight_service.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
import 'package:osborn_book/pdf/service/notes_service.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  static final Dio _dio = Dio();
  static final HighlightService _highlightService = HighlightService();
  static final NoteService _noteService = NoteService();
  static final BookmarkService _bookmarkService = BookmarkService();

  // Download PDF and save metadata to Hive
  static Future<bool> downloadPdf({
    required String urlId,
    required String title,
    required String pdfUrl,
    required String coverUrl,
  }) async {
    try {
      // Check if PDF is already downloaded
      if (HiveService.isPdfDownloaded(urlId)) {
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 1),
            message: 'PDF already downloaded.',
          ),
        );
        return true;
      }

      // Download the PDF file
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final pdfDir = Directory('${appDocDir.path}/pdfs');
      if (!await pdfDir.exists()) {
        await pdfDir.create(recursive: true);
      }

      final String pdfPath = '${pdfDir.path}/$title.pdf';
      await _dio.download(pdfUrl, pdfPath);

      // Download and save the cover image
      final String coverPath = await HiveService.saveCoverImage(urlId, coverUrl);

      // Save metadata to Hive
      final downloadedPdf = DownloadedPdf(
        urlId: urlId,
        title: title,
        localPath: pdfPath,
        coverImagePath: coverPath,
        downloadDate: DateTime.now(),
      );

      await HiveService.savePdf(downloadedPdf);

      Get.showSnackbar(
        const GetSnackBar(
          duration: Duration(seconds: 1),
          message: 'PDF downloaded successfully!',
        ),
      );

      return true;
    } catch (e) {
      print('Error downloading PDF: $e');
      return false;
    }
  }

  // Upload local highlights, notes, and bookmarks to the server when online
  static Future<void> syncLocalAnnotationsToServer(String urlId) async {
    if (await InternetConnectionChecker().hasConnection) {
      try {
        // Upload highlights
        final localHighlights = HiveService.getHighlightsForPdf(urlId);
        for (var localHighlight in localHighlights) {
          try {
            // Convert the local highlight to the format expected by the server
            List<Map<String, dynamic>> pdfTextLines = [];
            for (var line in localHighlight.pdfTextLines) {
              pdfTextLines.add(line.toMap());
            }

            final highlight = Highlight(
              id: localHighlight.id,
              publicationReaderId: localHighlight.publicationReaderId,
              pdfTextLines: pdfTextLines,
            );

            await _highlightService.createHighlight(highlight);
          } catch (e) {
            print('Error uploading highlight: $e');
          }
        }

        // Upload notes
        final localNotes = HiveService.getNotesForPdf(urlId);
        for (var localNote in localNotes) {
          try {
            final note = localNote.toNote();
            await _noteService.createNote(note);
          } catch (e) {
            print('Error uploading note: $e');
          }
        }

        // Upload bookmarks
        final localBookmarks = HiveService.getBookmarksForPdf(urlId);
        for (var localBookmark in localBookmarks) {
          try {
            final bookmark = localBookmark.toBookmark();
            await _bookmarkService.createBookmark(bookmark);
          } catch (e) {
            print('Error uploading bookmark: $e');
          }
        }
      } catch (e) {
        print('Error syncing local annotations to server: $e');
      }
    }
  }
}
