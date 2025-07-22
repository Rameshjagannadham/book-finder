import 'package:book_finder/core/database/book_db_helper.dart';
import 'package:book_finder/features/books/presentation/bloc/book_bloc.dart';
import 'package:book_finder/features/books/presentation/bloc/book_event.dart';
import 'package:book_finder/features/books/presentation/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BookDbHelper.init();
  runApp(const BookFinderApp());
}

class BookFinderApp extends StatelessWidget {
  const BookFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Finder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => BookBloc()..add(SearchBooks('all', page: 1)),
          ),
        ],
        child: const SearchPage(),
      ),
    );
  }
}
