// lib/features/books/presentation/bloc/book_event.dart
import 'package:book_finder/features/books/data/models/book_model.dart';
import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

class SearchBooks extends BookEvent {
  final String query;
  final int page;
  final List<BookModel> oldBooks;

  const SearchBooks(this.query, {this.page = 1, this.oldBooks = const []});

  @override
  List<Object?> get props => [query, page];
}
