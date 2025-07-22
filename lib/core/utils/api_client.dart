// lib/core/utils/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/books/data/models/book_model.dart';

class ApiClient {
  static const String apiEndPoint = 'https://openlibrary.org/search.json';

  static Future<List<BookModel>> searchBooks(String query, int page) async {
    final url = Uri.parse(
      '$apiEndPoint?q=$query&page=$page&fields=cover_edition_key,title,author_name',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // since result coming under the docs key. Retriving it from the response
      final List booksJson = data['docs'];
      return booksJson.map((e) => BookModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
