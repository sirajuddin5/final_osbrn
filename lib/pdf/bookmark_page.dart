import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/service/bookmark_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookmarksPage extends StatelessWidget {
  final PdfViewerController pdfController;
  final String urldId;

  const BookmarksPage({super.key, required this.pdfController, required this.urldId});

  @override
  Widget build(BuildContext context) {
    final bookmarkService = BookmarkService();
    return Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
          backgroundColor: Colors.deepPurple,
        ),
        body: FutureBuilder(
          future: bookmarkService.getBookmarks(urldId),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snap.hasError) {
              return Center(child: Text('Error: ${snap.error}'));
            }

            final data = snap.data;

            if (data == null || data.data == null || data.data!.isEmpty) {
              return const Center(child: Text('No bookmarks found'));
            }

            final list = data.data!;

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final bookmark = list[index];
                return ListTile(
                  title: Text('Page ${bookmark.page}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      if (bookmark.id != null) {
                        bookmarkService.deleteBookmark(bookmark.id!);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    pdfController.jumpToPage(bookmark.page);
                  },
                );
              },
            );
          },
        ));
  }
}
