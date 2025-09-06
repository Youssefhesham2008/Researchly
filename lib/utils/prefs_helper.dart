import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static const _kSavedPapers = 'saved_papers';
  static const _kForumPosts = 'forum_posts';
  static const _kSeenOnboarding = 'seen_onboarding';
  static const _kAuthUser = 'auth_user';

  static Future<void> setSeenOnboarding(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kSeenOnboarding, v);
  }

  static Future<bool> getSeenOnboarding() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kSeenOnboarding) ?? false;
  }

  static Future<void> savePapersJsonList(List<Map<String, dynamic>> papers) async {
    final p = await SharedPreferences.getInstance();
    final list = papers.map((e) => jsonEncode(e)).toList();
    await p.setStringList(_kSavedPapers, list);
  }

  static Future<List<Map<String, dynamic>>> loadPapersJsonList() async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_kSavedPapers) ?? [];
    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> saveForumJsonList(List<Map<String, dynamic>> posts) async {
    final p = await SharedPreferences.getInstance();
    final list = posts.map((e) => jsonEncode(e)).toList();
    await p.setStringList(_kForumPosts, list);
  }

  static Future<List<Map<String, dynamic>>> loadForumJsonList() async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList(_kForumPosts) ?? [];
    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  static Future<void> saveAuth(Map<String, dynamic> user) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kAuthUser, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> loadAuth() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_kAuthUser);
    if (s == null) return null;
    return jsonDecode(s) as Map<String, dynamic>;
  }
}


