import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:osborn_book/pdf/models/notes.dart';

part 'local_note.g.dart';

@HiveType(typeId: 4)
class LocalNote extends HiveObject {
  @HiveField(0)
  String? id;
  
  @HiveField(1)
  String publicationId;
  
  @HiveField(2)
  int page;
  
  @HiveField(3)
  double x;
  
  @HiveField(4)
  double y;
  
  @HiveField(5)
  String color;
  
  @HiveField(6)
  String text;
  
  @HiveField(7)
  String? createdAt;

  LocalNote({
    this.id,
    required this.publicationId,
    required this.page,
    required this.x,
    required this.y,
    required this.color,
    required this.text,
    this.createdAt,
  });
  
  // Convert from app's Note model to LocalNote
  factory LocalNote.fromNote(Note note) {
    return LocalNote(
      id: note.id,
      publicationId: note.publicationId,
      page: note.page,
      x: note.x,
      y: note.y,
      color: note.color,
      text: note.text,
      createdAt: note.createdAt,
    );
  }
  
  // Convert to app's Note model
  Note toNote() {
    return Note(
      id: id,
      publicationId: publicationId,
      page: page,
      x: x,
      y: y,
      color: color,
      text: text,
      createdAt: createdAt,
    );
  }

  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publication_id': publicationId,
      'page': page,
      'x': x,
      'y': y,
      'color': color,
      'text': text,
      'created_at': createdAt,
    };
  }
}
