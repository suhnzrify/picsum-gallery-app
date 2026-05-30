import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class ApiService {
  static const _base = 'https://picsum.photos/v2/list';

  /// Fetch photos with optional pagination.
  /// Picsum supports `page` and `limit` query parameters.
  static Future<List<Photo>> fetchPhotos({int page = 1, int limit = 30}) async {
    final uri = Uri.parse('$_base?page=$page&limit=$limit');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final List<dynamic> data = json.decode(res.body);
      return data.map((e) => Photo.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load photos: ${res.statusCode}');
    }
  }
}
