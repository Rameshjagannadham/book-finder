// lib/features/books/data/datasources/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class ApiClient {
  static Future<List<BookModel>> searchBooks(String query, int page) async {
    final url = Uri.parse(
      'https://enlibrary.org/api/search?q=$query&page=$page',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List booksJson = data['results'];
      return booksJson.map((e) => BookModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
