// lib/features/books/presentation/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/book_model.dart';
import '../bloc/book_bloc.dart';
import '../bloc/book_event.dart';
import '../bloc/book_state.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _query = '';
  List<BookModel> _allBooks = [];
  bool _isPaginating = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<BookBloc>().state;
      if (state is BookLoaded && state.hasMore) {
        context.read<BookBloc>().add(
          SearchBooks(_query, page: state.currentPage + 1, oldBooks: _allBooks),
        );
      }
    }
  }

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      _query = query;
      _allBooks.clear();
      _isPaginating = false;
      context.read<BookBloc>().add(SearchBooks(query));
    }
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          leading: Container(width: 50, height: 70, color: Colors.white),
          title: Container(
            width: double.infinity,
            height: 10,
            color: Colors.white,
          ),
          subtitle: Container(width: 150, height: 10, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBookItem(BookModel book, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.transparent,
          border: Border.all(color: Colors.grey, width: 2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0xfffbf2ef),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: ListTile(
          leading: Hero(
            tag: book.id,
            child: Image.network(
              book.thumbnailUrl,
              width: 50,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 50),
            ),
          ),
          title: Text('$i. ${book.title}'),
          subtitle: Text(book.author),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPage(book: book)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Book Finder'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Search books...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearch,
                  // this style not looking good, so commented out. Default was nice.
                  // style: ElevatedButton.styleFrom(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(4.0),
                  //   ),
                  // ),
                  child: const Text('Search', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<BookBloc, BookState>(
              listener: (context, state) {
                if (state is BookLoaded) {
                  _allBooks = state.books;
                }
              },
              builder: (context, state) {
                if (state is BookLoading) return _buildShimmer();
                if (state is BookLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async => _onSearch(),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _allBooks.length,
                      itemBuilder: (_, i) => _buildBookItem(_allBooks[i], i),
                      // separatorBuilder: (_, __) => const Divider(),
                    ),
                  );
                }
                if (state is BookError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('Search for a book'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
