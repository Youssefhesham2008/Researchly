import 'dart:convert';

class Paper {
  final String id;
  final String title;
  final List<String> authors;
  final String summary;
  final DateTime publishedDate;
  final List<String> categories;
  final String paperUrl;
  final String? imageUrl;

  Paper({
    required this.id,
    required this.title,
    required this.authors,
    required this.summary,
    required this.publishedDate,
    required this.categories,
    required this.paperUrl,
    this.imageUrl,
  });

  /// 🆕 Factory constructor for creating Paper from API
  factory Paper.fromApi({
    required String id,
    required String title,
    required List<String> authors,
    required String summary,
    required DateTime publishedDate,
    required List<String> categories,
    required String paperUrl,
    String? imageUrl,
  }) {
    return Paper(
      id: id,
      title: title,
      authors: authors,
      summary: summary,
      publishedDate: publishedDate,
      categories: categories,
      paperUrl: paperUrl,
      imageUrl: imageUrl,
    );
  }

  /// copyWith to update Paper object
  Paper copyWith({
    String? id,
    String? title,
    List<String>? authors,
    String? summary,
    DateTime? publishedDate,
    List<String>? categories,
    String? paperUrl,
    String? imageUrl,
  }) {
    return Paper(
      id: id ?? this.id,
      title: title ?? this.title,
      authors: authors ?? this.authors,
      summary: summary ?? this.summary,
      publishedDate: publishedDate ?? this.publishedDate,
      categories: categories ?? this.categories,
      paperUrl: paperUrl ?? this.paperUrl,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'summary': summary,
      'publishedDate': publishedDate.toIso8601String(),
      'categories': categories,
      'paperUrl': paperUrl,
      'imageUrl': imageUrl,
    };
  }

  factory Paper.fromJson(Map<String, dynamic> json) {
    return Paper(
      id: json['id'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      summary: json['summary'],
      publishedDate: DateTime.parse(json['publishedDate']),
      categories: List<String>.from(json['categories']),
      paperUrl: json['paperUrl'],
      imageUrl: json['imageUrl'],
    );
  }

  static String encode(List<Paper> papers) => json.encode(
    papers.map<Map<String, dynamic>>((p) => p.toJson()).toList(),
  );

  static List<Paper> decode(String papers) =>
      (json.decode(papers) as List<dynamic>)
          .map<Paper>((p) => Paper.fromJson(p))
          .toList();
}









