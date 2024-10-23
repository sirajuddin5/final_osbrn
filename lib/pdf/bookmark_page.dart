import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class BookmarksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView.builder(
            itemCount: appState.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = appState.bookmarks[index];
              return ListTile(
                title: Text('Page ${bookmark.pageNumber}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    appState.removeBookmark(bookmark.id);
                  },
                ),
                onTap: () {
                  // Navigate to the specific page in the PDF
                  Navigator.of(context).pop(bookmark.pageNumber);
                },
              );
            },
          );
        },
      ),
    );
  }
}