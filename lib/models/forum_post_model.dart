import 'comment_model.dart';

class ForumPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final String? paperId; // link to a paper if created from Details
  final DateTime createdAt;
  final List<Comment> comments;

  ForumPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    this.paperId,
    required this.createdAt,
    required this.comments,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'author': author,
    'paperId': paperId,
    'createdAt': createdAt.toIso8601String(),
    'comments': comments.map((c) => c.toJson()).toList(),
  };

  factory ForumPost.fromJson(Map<String, dynamic> json) => ForumPost(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    author: json['author'],
    paperId: json['paperId'],
    createdAt: DateTime.parse(json['createdAt']),
    comments: (json['comments'] as List).map((e) => Comment.fromJson(e)).toList(),
  );
}






