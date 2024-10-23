

import 'package:flutter/material.dart';

import '../networking/publication_model.dart';
import 'book_card.dart';

class AllBooksWidget extends StatelessWidget {
  const AllBooksWidget({
    super.key,
    required this.futurePublications,
  });

  final Future<List<Publication>> futurePublications;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<Publication>>(
        future: futurePublications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            // Changed ListView.builder to GridView.builder
            return GridView.builder(
              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
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
                  url: publication.pathUrl, urlToPdf: publication.urlToPdf,// Changed to use coverUrl for imagePath

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