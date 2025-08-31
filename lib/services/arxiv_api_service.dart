import 'dart:convert'; // For json.decode
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart'; // For XML parsing
import 'package:scisky_social_network/models/paper_model.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class ArxivApiException implements Exception {
  final String message;
  ArxivApiException(this.message);

  @override
  String toString() => 'ArxivApiException: $message';
}
class ArxivApiService {
  static const String _baseUrl = 'https://export.arxiv.org/api/query';

  Future<List<Paper>> searchPapers({
    String searchQuery = 'AI',
    String sortBy = 'submittedDate',
    String sortOrder = 'descending',
    int start = 0,
    int maxResults = 10,
  }) async {
    // handle categories vs general search
    final String query = searchQuery.startsWith("cat:")
        ? Uri.encodeComponent(searchQuery)
        : "all:${Uri.encodeComponent(searchQuery)}";

    final url = Uri.parse(
        '$_baseUrl?search_query=$query&sortBy=$sortBy&sortOrder=$sortOrder&start=$start&max_results=$maxResults');

    debugPrint('Fetching from arXiv API: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final xmlTransformer = Xml2Json();
        xmlTransformer.parse(response.body);
        final jsonString = xmlTransformer.toGData();
        final jsonData = json.decode(jsonString);

        if (jsonData['feed'] == null || jsonData['feed']['entry'] == null) {
          debugPrint('No entries found in arXiv response or unexpected format.');
          return [];
        }

        final List<dynamic> entries = jsonData['feed']['entry'] is List
            ? jsonData['feed']['entry']
            : [jsonData['feed']['entry']];

        return entries.map((entry) => Paper.fromArxivEntry(entry)).toList();
      } else {
        throw ArxivApiException('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw ArxivApiException('Unexpected error: ${e.toString()}');
    }
  }
}


// class ArxivApiService {
//   // static const String _baseUrl = 'http://export.arxiv.org/api/query';
//   static const String _baseUrl = 'https://export.arxiv.org/api/query';
//
//   Future<List<Paper>> searchPapers({
//     String searchQuery = 'AI', // Default search query
//     String sortBy = 'submittedDate', // 'relevance', 'lastUpdatedDate', 'submittedDate'
//     String sortOrder = 'descending', // 'ascending', 'descending'
//     int start = 0,
//     int maxResults = 10,
//   }) async {
//     // Construct the query URL
//     // Example: http://export.arxiv.org/api/query?search_query=ti:AI+AND+cat:cs.AI&sortBy=submittedDate&sortOrder=descending&start=0&maxResults=10
//     // For a general search, we can use 'all:[query]' or just 'search_query=[query]'
//     // For categories, it's like 'cat:cs.AI' or 'cat:stat.ML'
//     // Let's keep it simple for now and search in all fields.
//     final String query = 'all:${Uri.encodeComponent(searchQuery)}';
//     // final url = Uri.parse(
//     //     '$_baseUrl?search_query=$query&sortBy=$sortBy&sortOrder=$sortOrder&start=$start&max_results=$maxResults');
//     final url = Uri.parse(
//         '$_baseUrl?search_query=$query&sortBy=$sortBy&sortOrder=$sortOrder&start=$start&max_results=$maxResults');
//
//     debugPrint('Fetching from arXiv API: $url');
//
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final xmlTransformer = Xml2Json();
//         xmlTransformer.parse(response.body);
//         final jsonString = xmlTransformer.toGData(); // GData gives a more standard JSON
//         final jsonData = json.decode(jsonString);
//
//         if (jsonData['feed'] == null || jsonData['feed']['entry'] == null) {
//           debugPrint('No entries found in arXiv response or unexpected format.');
//           return [];
//         }
//
//         final List<dynamic> entries = jsonData['feed']['entry'] is List
//             ? jsonData['feed']['entry']
//             : [jsonData['feed']['entry']]; // Handle single entry case
//
//         List<Paper> papers = [];
//         for (var entryData in entries) {
//           try {
//             papers.add(Paper.fromArxivEntry(entryData));
//           } catch (e) {
//             debugPrint('Error parsing an arXiv entry: $entryData \nError: $e');
//             // Optionally skip this paper or handle error
//           }
//         }
//         debugPrint('Fetched ${papers.length} papers successfully.');
//         return papers;
//       } else {
//         debugPrint('arXiv API Error: ${response.statusCode} - ${response.body}');
//         throw ArxivApiException(
//             'Failed to fetch papers. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error fetching or parsing papers: $e');
//       if (e is ArxivApiException) rethrow;
//       throw ArxivApiException('An unexpected error occurred: ${e.toString()}');
//     }
//   }
// }
