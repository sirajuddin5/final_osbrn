import 'package:flutter/material.dart';

import '../networking/publication_model.dart';
import '../pdf/downloaded_pdf_list.dart';
import 'book_card.dart';

class AllBooksWidget extends StatefulWidget {
  const AllBooksWidget({
    super.key,
    required this.futurePublications,
    required this.onReload,
  });

  final Future<List<Publication>> futurePublications;
  final VoidCallback onReload;

  @override
  State<AllBooksWidget> createState() => _AllBooksWidgetState();
}

class _AllBooksWidgetState extends State<AllBooksWidget> {
  Widget noInternetDialog(BuildContext context) {
    return AlertDialog(
      title: Text("No Internet Connection"),
      content: Text("Please check your internet connection and try again."),
      actions: <Widget>[
        TextButton(
          child: Text("Go to Download"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DownloadedPdfsPage()),
            );
          },
        ),
        TextButton(
          child: Text("Reload"),
          onPressed: () {
            Navigator.pop(context); // Close the dialog first
            widget.onReload(); // Call the onReload function to fetch data again
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Publication>>(
        future: widget.futurePublications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else
          if (snapshot.error.toString().contains('No internet connection')) {
            // Show the no internet dialog
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (context) => noInternetDialog(context),
              );
            });
            return Center(child: Text("Loading...")); // Indicate loading while showing dialog
          }
            else if (snapshot.hasData) {
            // Changed ListView.builder to GridView.builder
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final publication = snapshot.data![index];
                // Use BookCard instead of ListTile
                return BookCard(
                  title: publication.title,
                  imagePath: publication.coverUrl,
                  url: publication.pathUrl,
                  urlToPdf: publication.urlToPdf, // Changed to use coverUrl for imagePath
                );
              },
            );
          }
          return Center(child: Text("No data available"));
        },
      ),
    );
  }
}
