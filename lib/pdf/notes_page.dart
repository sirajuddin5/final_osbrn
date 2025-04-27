import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:osborn_book/getx/pdf_controller.dart';
import 'package:osborn_book/pdf/models/local_note.dart';
import 'package:osborn_book/pdf/service/hive_service.dart';
import 'package:osborn_book/pdf/service/notes_service.dart';
import 'package:osborn_book/pdf/utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

class NotesPage extends StatefulWidget {
  final PdfViewerController pdfViewerController;
  final String urlId;

  const NotesPage(
      {super.key,
      required this.pdfViewerController,
      required this.urlId,
      this.isLocal = false});

  final bool? isLocal;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  RxList<LocalNote>? localList;

  @override
  void initState() {
    localList =
        widget.isLocal! ? HiveService.getNotesForPdf(widget.urlId).obs : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noteService = NoteService();
    final pdfController = Get.find<PdfController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: localList != null
          ? Obx(
              () => localList!.isNotEmpty
                  ? ListView.builder(
                      itemCount: localList!.length,
                      itemBuilder: (context, index) {
                        final note = localList![index];
                        // Use the same UI as the remote notes
                        return Dismissible(
                          key: Key(note.id.toString()),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) async {
                            await HiveService.deleteNote(
                                widget.urlId, note.id!);
                            localList?.removeWhere((n) => n.id == note.id);
                            widget.pdfViewerController.removeAllAnnotations();
                            updateLocalAnnotations(
                                widget.urlId, widget.pdfViewerController);
                          },
                          child: ListTile(
                            title: Text(note.text),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Page ${note.page}",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Text(
                                  "At ${note.x.toStringAsFixed(2)} ${note.y.toStringAsFixed(2)}",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () async {
                                  await HiveService.deleteNote(
                                      widget.urlId, note.id!);
                                  localList
                                      ?.removeWhere((n) => n.id == note.id);
                                  widget.pdfViewerController
                                      .removeAllAnnotations();  
                                  updateLocalAnnotations(
                                      widget.urlId, widget.pdfViewerController);
                                },
                                icon: const Icon(Icons.delete)),
                            onTap: () {
                              widget.pdfViewerController.jumpToPage(note.page);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No Notes Found'),
                    ),
            )
          :
          // FutureBuilder(
          //     future: noteService.getNotes(widget.urlId),
          //     builder: (context, snap) {
          //       if (snap.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //       if (snap.hasError) {
          //         return Center(child: Text('Error: ${snap.error}'));
          //       }

          //       final data = snap.data;
          //       if (data == null || data.data == null || data.data!.isEmpty) {
          //         return const Center(child: Text('No notes found'));
          //       }

          //       final list = data.data!;

          //       return
          NetworkList(
              pdfController: pdfController,
              noteService: noteService,
              widget: widget, urlId: widget.urlId),
    );
  }
}

class NetworkList extends StatelessWidget {
  const NetworkList({
    super.key,
    required this.pdfController,
    required this.noteService,
    required this.widget,
    required this.urlId,
  });

  final PdfController pdfController;
  final NoteService noteService;
  final NotesPage widget;
  final String urlId;

  @override
  Widget build(BuildContext context) {
    return Obx(() => (pdfController.notesMap[urlId] ?? []).isNotEmpty
        ? ListView.builder(
            itemCount: (pdfController.notesMap[urlId] ?? []).length,
            itemBuilder: (context, index) {
              final note = (pdfController.notesMap[urlId] ?? [])[index];
              return Dismissible(
                key: Key(note.id!),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await noteService.deleteNote(note.id!, note.publicationId);
                  pdfController.removeNote(urlId, note);
                  Get.showSnackbar(
                    const GetSnackBar(
                      message: 'Note deleted',
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(note.text),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Page ${note.page}",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        "At ${note.x?.toStringAsFixed(2)} ${note.y?.toStringAsFixed(2)}",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () async {
                        await noteService.deleteNote(
                            note.id!, note.publicationId);
                        pdfController.removeNote(urlId, note);
                        Get.showSnackbar(
                          const GetSnackBar(
                            message: 'Note deleted',
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete)),
                  onTap: () {
                    widget.pdfViewerController.jumpToPage(note.page);
                    Navigator.pop(context);
                  },
                ),
              );
              // },
              // );
            },
          )
        : const Center(
            child: Text('No notes found'),
          ));
  }
}
