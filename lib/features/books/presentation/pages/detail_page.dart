// DetailPage with rotating cover and save to SQLite
// lib/features/books/presentation/pages/detail_page.dart
import 'dart:math';
import 'package:book_finder/core/database/book_db_helper.dart';
import 'package:book_finder/features/books/data/models/book_model.dart';
import 'package:flutter/material.dart';
// import '../../../../core/database/book_db_helper.dart';
// import '../../data/models/book_model.dart';
// import '../../../core/database/book_db_helper.dart';

class DetailPage extends StatefulWidget {
  final BookModel book;
  const DetailPage({super.key, required this.book});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _rotation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveBook() async {
    await BookDbHelper.saveBook(widget.book.toJson());
    setState(() => _saved = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Hero(
              tag: widget.book.id,
              child: AnimatedBuilder(
                animation: _rotation,
                builder: (_, child) =>
                    Transform.rotate(angle: _rotation.value, child: child),
                child: Image.network(
                  widget.book.thumbnailUrl,
                  width: 120,
                  height: 160,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'by ${widget.book.author}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: Icon(_saved ? Icons.check : Icons.save),
              label: Text(_saved ? 'Saved' : 'Save Book'),
              onPressed: _saved ? null : _saveBook,
            ),
          ],
        ),
      ),
    );
  }
}
