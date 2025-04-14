import 'package:flutter/material.dart';
import 'package:osborn_book/pdf/app_state.dart';
import 'package:provider/provider.dart';

class HighlightsPage extends StatelessWidget {
  final Function(int pageNumber, String text, double x, double y, double width, double height, int color)? onViewHighlight;

  const HighlightsPage({Key? key, this.onViewHighlight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final highlights = appState.highlights;

    return Scaffold(
      appBar: AppBar(
        title: Text('Highlights'),
      ),
      body: highlights.isEmpty
          ? Center(child: Text('No highlights found'))
          : ListView.builder(
        itemCount: highlights.length,
        itemBuilder: (context, index) {
          final highlight = highlights[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                highlight.text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Page: ${highlight.pageNumber}'),
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color(highlight.color),
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Text(
                        'Position: (${highlight.x.toStringAsFixed(1)}, ${highlight.y.toStringAsFixed(1)})',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Text(
                    'Size: ${highlight.width.toStringAsFixed(1)} × ${highlight.height.toStringAsFixed(1)}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                if (onViewHighlight != null) {
                  onViewHighlight!(
                    highlight.pageNumber,
                    highlight.text,
                    highlight.x,
                    highlight.y,
                    highlight.width,
                    highlight.height,
                    highlight.color,
                  );
                  Navigator.pop(context);
                } else {
                  // Fallback to just returning the page number
                  Navigator.pop(context, highlight.pageNumber);
                }
              },
            ),
          );
        },
      ),
    );
  }
}