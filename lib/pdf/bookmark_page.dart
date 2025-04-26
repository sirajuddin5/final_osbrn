import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/models/local_bookmark.dart';
import 'package:osborn_book/pdf/service/bookmark_service.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'app_state.dart';

class BookmarksPage extends StatefulWidget {
  final PdfViewerController pdfController;
  final String urldId;

  const BookmarksPage(
      {super.key,
      required this.pdfController,
      required this.urldId,
      this.isLocal = false});

  final bool? isLocal;

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<LocalBookmark>? localList;

  @override
  void initState() {
    super.initState();
    localList =
        widget.isLocal! ? HiveService.getBookmarksForPdf(widget.urldId) : null;
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkService = BookmarkService();
    return Scaffold(
        appBar: AppBar(
          title: Text('Bookmarks'),
          backgroundColor: Colors.deepPurple,
        ),
        body: !widget.isLocal!
            ? FutureBuilder(
                future: bookmarkService.getBookmarks(widget.urldId),
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
                          onPressed: () async {
                            if (bookmark.id != null) {
                              await bookmarkService.deleteBookmark(
                                  bookmark.id!, bookmark.publicationId);

                              setState(() {});
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          widget.pdfController.jumpToPage(bookmark.page);
                        },
                      );
                    },
                  );
                },
              )
            : ListView.builder(
                itemCount: localList!.length,
                itemBuilder: (context, index) {
                  final bookmark = localList![index];
                  return ListTile(
                    title: Text('Page ${bookmark.page}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (bookmark.id != null) {
                          await HiveService.deleteBookmark(
                              widget.urldId, bookmark.id!);
                          setState(() {});
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      widget.pdfController.jumpToPage(bookmark.page);
                    },
                  );
                },
              ));
  }
}
