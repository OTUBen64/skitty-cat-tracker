import 'dart:convert';
import 'package:http/http.dart' as http;

class CatFactService {
  static Future<String> fetchFact() async {
    final r = await http.get(Uri.parse('https://catfact.ninja/fact'));
    if (r.statusCode == 200) {
      return (jsonDecode(r.body)['fact'] as String).trim();
    }
    throw Exception('Failed to fetch cat fact (${r.statusCode})');
  }
}
