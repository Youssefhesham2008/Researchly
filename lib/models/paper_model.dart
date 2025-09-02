class Paper {
  final String id;
  final String title;
  final List<String> authors;
  final String summary;
  final DateTime publishedDate;
  final List<String> categories;
  final String paperUrl;

  Paper({
    required this.id,
    required this.title,
    required this.authors,
    required this.summary,
    required this.publishedDate,
    required this.categories,
    required this.paperUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'authors': authors,
    'summary': summary,
    'publishedDate': publishedDate.toIso8601String(),
    'categories': categories,
    'paperUrl': paperUrl,
  };

  factory Paper.fromJson(Map<String, dynamic> json) => Paper(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    authors: (json['authors'] as List).cast<String>(),
    summary: json['summary'] ?? '',
    publishedDate: DateTime.tryParse(json['publishedDate'] ?? '') ?? DateTime.now(),
    categories: (json['categories'] as List).cast<String>(),
    paperUrl: json['paperUrl'] ?? '',
  );
}




