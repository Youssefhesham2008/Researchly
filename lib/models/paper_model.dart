import 'package:flutter/foundation.dart';

@immutable
class Paper {
  final String id;
  final String title;
  final List<String> authors;
  final String summary;
  final String paperUrl; // Link to the PDF or arXiv page
  final DateTime publishedDate;
  final List<String> categories; // e.g., ['cs.AI', 'stat.ML']

  const Paper({
    required this.id,
    required this.title,
    required this.authors,
    required this.summary,
    required this.paperUrl,
    required this.publishedDate,
    required this.categories,
  });

  // A factory constructor to create a Paper from a simplified JSON map
  // This will need to be adjusted based on the actual API response structure.
  // For arXiv, the response is XML, so parsing will be more involved.
  // This is a placeholder for how we might map data once parsed.
  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      id: json['id'] as String? ?? 'unknown_id',
      title: json['title'] as String? ?? 'Untitled',
      authors: (json['authors'] as List<dynamic>?)
              ?.map((author) => author['name'] as String)
              .toList() ??
          <String>[],
      summary: json['summary'] as String? ?? 'No summary available.',
      paperUrl: json['paperUrl'] as String? ?? '',
      publishedDate: json['publishedDate'] != null
          ? DateTime.tryParse(json['publishedDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((category) => category as String)
              .toList() ??
          <String>[],
    );
  }

  // Placeholder for when we implement actual XML parsing from arXiv
  factory Paper.fromArxivEntry(dynamic entry) {
    // This is highly simplified and assumes 'entry' is a pre-parsed map
    // Actual arXiv XML parsing will be more complex.
    // Example: extracting from <entry>...</entry> in Atom feed

    String extractText(dynamic field) {
      if (field is String) return field;
      if (field is Map && field.containsKey('\$t')) return field['\$t'] as String;
      return '';
    }

    List<String> extractAuthors(dynamic authorField) {
      if (authorField == null) return [];
      if (authorField is List) {
        return authorField
            .map((a) => (a is Map && a.containsKey('name') && a['name'] is Map && a['name'].containsKey('\$t')) ? a['name']['\$t'] as String : 'Unknown Author')
            .toList();
      }
      if (authorField is Map && authorField.containsKey('name') && authorField['name'] is Map && authorField['name'].containsKey('\$t')) {
        return [authorField['name']['\$t'] as String];
      }
      return ['Unknown Author'];
    }
    
    String findPdfLink(dynamic links) {
      if (links is List) {
        for (var link in links) {
          if (link is Map && link['@type'] == 'application/pdf' && link.containsKey('@href')) {
            return link['@href'] as String;
          }
        }
        // Fallback to HTML link if PDF not found
         for (var link in links) {
          if (link is Map && link['@rel'] == 'alternate' && link['@type'] == 'text/html' && link.containsKey('@href')) {
            return link['@href'] as String;
          }
        }
      }
      return '';
    }

    List<String> extractCategories(dynamic categoryField) {
       if (categoryField == null) return [];
       if (categoryField is List) {
         return categoryField
            .map((c) => (c is Map && c.containsKey('@term')) ? c['@term'] as String : '')
            .where((c) => c.isNotEmpty)
            .toList();
       }
        if (categoryField is Map && categoryField.containsKey('@term')) {
        return [categoryField['@term'] as String];
      }
       return [];
    }

    return Paper(
      id: extractText(entry['id']),
      title: extractText(entry['title']).replaceAll('\n', ' ').trim(),
      authors: extractAuthors(entry['author']),
      summary: extractText(entry['summary']).replaceAll('\n', ' ').trim(),
      paperUrl: findPdfLink(entry['link']),
      publishedDate: DateTime.tryParse(extractText(entry['published'])) ?? DateTime.now(),
      categories: extractCategories(entry['category']),
    );
  }


  @override
  String toString() {
    return 'Paper(id: $id, title: $title, authors: $authors, summary: $summary, paperUrl: $paperUrl, publishedDate: $publishedDate, categories: $categories)';
  }
}
