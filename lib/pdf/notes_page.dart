
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

// class NotesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notes'),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Consumer<AppState>(
//         builder: (context, appState, child) {
//           return FutureBuilder<List<Map<String, dynamic>>>(
//             future: appState.getNotes(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               }
//               final notes = snapshot.data ?? [];
//               return ListView.builder(
//                 itemCount: notes.length,
//                 itemBuilder: (context, index) {
//                   final note = notes[index];
//                   return Dismissible(
//                     key: Key(note['id'].toString()),
//                     background: Container(
//                       color: Colors.red,
//                       alignment: Alignment.centerRight,
//                       padding: EdgeInsets.only(right: 20.0),
//                       child: Icon(Icons.delete, color: Colors.white),
//                     ),
//                     direction: DismissDirection.endToStart,
//                     onDismissed: (direction) {
//                       appState.removeNote(note['id']);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Note deleted')),
//                       );
//                     },
//                     child: ListTile(
//                       title: Text('Page: ${note['pageNumber']}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             note['text'],
//                             softWrap: true,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                           Text(
//                             note['note'],
//                             softWrap: true,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                         ],
//                       ),
//                       onTap: () {
//                         Navigator.pop(context, note['pageNumber']);
//                       },
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: appState.getNotes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final notes = snapshot.data ?? [];
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Dismissible(
                    key: Key(note['id'].toString()),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      appState.removeNote(note['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Note deleted')),
                      );
                    },
                    child: ListTile(
                      title: Text('Page: ${note['pageNumber']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note['text'],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            note['note'],
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context, note['pageNumber']);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
