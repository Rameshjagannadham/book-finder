// lib/features/books/data/models/book_model.dart
import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final String description;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.description,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['cover_edition_key'] ?? '',
      title: json['title'] ?? 'No Title',
      author: (json['author_name'] ?? 'Unknown').toString(),
      thumbnailUrl:
          'https://covers.openlibrary.org/b/olid/${json['cover_edition_key']}.jpg',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'thumbnail': thumbnailUrl,
    'description': description,
  };

  @override
  List<Object?> get props => [id, title, author, thumbnailUrl, description];
}
