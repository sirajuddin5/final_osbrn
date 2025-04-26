import 'package:osborn_book/pdf/models/bookmarks.dart';
import 'package:osborn_book/pdf/models/highlights.dart';
import 'package:osborn_book/pdf/models/mark.dart';
import 'package:osborn_book/pdf/models/notes.dart';

class BaseResponseModel<T> {
  final bool? status;
  final String? message;
  final T? data;

  BaseResponseModel({this.status, this.message, this.data});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    final type = T;
    dynamic data;

    if (type == Highlight) {
      data = Highlight.fromJson(json['data']);
    } else if (type == List<Highlight>) {
      data = (json['data'] as List).map((e) => Highlight.fromJson(e)).toList();
    } else if (type == Bookmark) {
      data = Bookmark.fromJson(json['data']["data"]);
    } else if (type == List<Bookmark>) {
      data = (json['data']["bookmarks"] as List)
          .map((e) => Bookmark.fromJson(e))
          .toList();
    } else if (type == Mark) {
      data = Mark.fromJson(json['data']["data"]);
    } else if (type == List<Mark>) {
      data = (json['data']["bookmarks"] as List).map((e) => Mark.fromJson(e)).toList();
    } else if (type == Note) {
      data = Note.fromJson(json['data']["note"]);
    } else if (type == List<Note>) {
      data = (json['data'] as List).map((e) => Note.fromJson(e)).toList();
    } else {
      data = null;
    }

    return BaseResponseModel(
      status: json['status'],
      message: json['message'],
      data: data,
    );
  }
}
