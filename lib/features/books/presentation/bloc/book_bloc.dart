// lib/features/books/presentation/bloc/book_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/api_client.dart';
import 'book_event.dart';
import 'book_state.dart';
// import '../../data/models/book_model.dart';
// import '../../../core/utils/api_client.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(BookInitial()) {
    on<SearchBooks>(_onSearchBooks);
  }

  Future<void> _onSearchBooks(
    SearchBooks event,
    Emitter<BookState> emit,
  ) async {
    final currentPage = event.page;
    if (currentPage == 1) emit(BookLoading());

    try {
      // emit(BookLoading());
      //  final result = await repository.searchBooks(event.query, page: currentPage);
      //   final books = [...event.oldBooks, ...result.books];

      final result = await ApiClient.searchBooks(event.query, event.page);
      final books = [...event.oldBooks, ...result];
      emit(
        BookLoaded(
          books,
          hasMore: books.length == 100,
          currentPage: event.page,
        ),
      );
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}
