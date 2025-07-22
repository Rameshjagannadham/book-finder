// lib/features/books/presentation/bloc/book_state.dart
import 'package:equatable/equatable.dart';
import '../../data/models/book_model.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<BookModel> books;
  final bool hasMore;
  final int currentPage;

  const BookLoaded(this.books, {this.hasMore = true, this.currentPage = 1});

  @override
  List<Object?> get props => [books, hasMore, currentPage];
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}
