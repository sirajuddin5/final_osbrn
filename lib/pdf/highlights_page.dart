import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'highlight_model.dart'; // Import the Highlight model


class HighlightsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Highlights'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return ListView.builder(
            itemCount: appState.highlights.length,
            itemBuilder: (context, index) {
              final highlight = appState.highlights[index];
              return Dismissible(
                key: Key(highlight.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  appState.removeHighlight(highlight.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Highlight deleted'),duration: Duration(seconds: 1),),
                  );
                },
                child: ListTile(
                  title: Text('Page: ${highlight.pageNumber}'),
                  subtitle: Text(
                    highlight.text,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  onTap: () {
                    Navigator.pop(context, highlight.pageNumber);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}