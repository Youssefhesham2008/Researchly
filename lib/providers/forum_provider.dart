import 'dart:math';
import 'package:flutter/material.dart';
import '../models/forum_post_model.dart';
import '../models/comment_model.dart';
import '../utils/prefs_helper.dart';

class ForumProvider extends ChangeNotifier {
  final List<ForumPost> _posts = [];

  List<ForumPost> get posts => List.unmodifiable(_posts);

  Future<void> loadSaved() async {
    final list = await PrefsHelper.loadForumJsonList();
    _posts
      ..clear()
      ..addAll(list.map((e) => ForumPost.fromJson(e)));
    notifyListeners();
  }

  Future<void> _save() async {
    await PrefsHelper.saveForumJsonList(_posts.map((e) => e.toJson()).toList());
  }

  ForumPost? getPostByPaperId(String paperId) {
    try {
      return _posts.firstWhere((p) => p.paperId == paperId);
    } catch (_) {
      return null;
    }
  }

  Future<ForumPost> createOrGetPostForPaper({
    required String paperId,
    required String title,
    required String content,
    required String author,
  }) async {
    final existing = getPostByPaperId(paperId);
    if (existing != null) return existing;

    final id = _randId();
    final post = ForumPost(
      id: id,
      title: title,
      content: content,
      author: author,
      paperId: paperId,
      createdAt: DateTime.now(),
      comments: [],
    );
    _posts.insert(0, post);
    await _save();
    notifyListeners();
    return post;
  }

  Future<void> addComment(String postId, String author, String text) async {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx < 0) return;
    final c = Comment(
      id: _randId(),
      author: author,
      text: text,
      createdAt: DateTime.now(),
    );
    _posts[idx].comments.add(c);
    await _save();
    notifyListeners();
  }

  Future<void> createPost(String title, String content, String author) async {
    final post = ForumPost(
      id: _randId(),
      title: title,
      content: content,
      author: author,
      paperId: null,
      createdAt: DateTime.now(),
      comments: [],
    );
    _posts.insert(0, post);
    await _save();
    notifyListeners();
  }

  String _randId() => DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(9999).toString();
}


