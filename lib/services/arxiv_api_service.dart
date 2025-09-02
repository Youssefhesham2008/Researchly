// lib/services/arxiv_api_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../models/paper_model.dart';

class ArxivApiService {
  // خريطة المجالات للـ arXiv categories
  static const Map<String, String> categoryToArxiv = {
    'AI': 'cs.AI',
    'Physics': 'physics.gen-ph',
    'Medicine': 'q-bio.BM',
    'Math': 'math',
    'Biology': 'q-bio',
  };

  /// جلب أحدث الأوراق (حسب submittedDate)
  Future<List<Paper>> fetchLatestPapers({
    String? category,
    int start = 0,
    int maxResults = 20,
  }) async {
    return fetchPapers(
      category: category,
      start: start,
      maxResults: maxResults,
    );
  }

  /// بحث عام مع (query) اختياري + تصفية بفئة
  Future<List<Paper>> fetchPapers({
    String? query,
    String? category,
    int start = 0,
    int maxResults = 20,
  }) async {
    final parts = <String>[];

    // query
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().replaceAll(' ', '+');
      parts.add('all:$q');
    } else {
      parts.add('all:*'); // الكل
    }

    // category
    if (category != null && category.isNotEmpty) {
      final code = categoryToArxiv[category] ?? category; // يقبل كود جاهز أيضاً
      parts.add('cat:$code');
    }

    final searchQuery = parts.join('+AND+');

    final targetUrl =
        'http://export.arxiv.org/api/query?search_query=$searchQuery'
        '&start=$start&max_results=$maxResults'
        '&sortBy=submittedDate&sortOrder=descending';

    final body = await _getWithCorsIfWeb(targetUrl);
    if (body == null || body.isEmpty) {
      return [];
    }

    final xmlText = _extractFeedXml(body);
    if (xmlText == null) {
      // لو حتى بعد الاستخراج مفيش feed صالح
      return [];
    }

    try {
      final doc = xml.XmlDocument.parse(xmlText);
      final entries = doc.findAllElements('entry');

      final result = <Paper>[];
      for (final e in entries) {
        final id = e.getElement('id')?.text.trim() ?? '';
        final title =
        (e.getElement('title')?.text ?? '').replaceAll('\n', ' ').trim();
        final summary =
        (e.getElement('summary')?.text ?? '').replaceAll('\n', ' ').trim();

        final publishedStr = e.getElement('published')?.text ?? '';
        final published =
            DateTime.tryParse(publishedStr) ?? DateTime.now();

        final authors = e
            .findElements('author')
            .map((a) => a.getElement('name')?.text ?? '')
            .where((s) => s.isNotEmpty)
            .toList();

        final cats = e
            .findElements('category')
            .map((c) => c.getAttribute('term') ?? '')
            .where((s) => s.isNotEmpty)
            .toList();

        result.add(
          Paper(
            id: id,
            title: title,
            authors: authors.isEmpty ? ['Unknown'] : authors,
            summary: summary,
            publishedDate: published,
            categories: cats.isEmpty ? ['misc'] : cats,
            paperUrl: id,
          ),
        );
      }

      return result;
    } catch (e) {
      // في حالة خطأ XML
      // print('XML parse error: $e');
      return [];
    }
  }

  /// بحث بالنص مع اختيار فئة اختياري
  Future<List<Paper>> searchPapers({
    required String query,
    String? category,
    int start = 0,
    int maxResults = 20,
  }) {
    return fetchPapers(
      query: query,
      category: category,
      start: start,
      maxResults: maxResults,
    );
  }

  /// أحدث أوراق Randomized لصفحة "Latest" (مثلاً تجيب 100 وتخلط وتاخد 20)
  Future<List<Paper>> fetchLatestPapersRandomized({
    String? category,
    int poolSize = 100,
    int take = 20,
  }) async {
    final pool = await fetchLatestPapers(
      category: category,
      start: 0,
      maxResults: poolSize,
    );
    pool.shuffle();
    if (take >= pool.length) return pool;
    return pool.sublist(0, take);
  }

  // ===================== Helpers =====================

  /// على الويب نستخدم CORS proxy؛ على الموبايل/الديسكتوب نطلب الـ URL مباشرة
  Future<String?> _getWithCorsIfWeb(String targetUrl) async {
    try {
      if (!kIsWeb) {
        final resp = await http
            .get(Uri.parse(targetUrl), headers: _headers)
            .timeout(const Duration(seconds: 20));
        if (resp.statusCode == 200) return resp.body;
        return null;
      }

      // على الويب: جرّب أكثر من بروكسي بالترتيب
      final proxies = <String>[
        // يعيد المحتوى خام بدون JSON wrapper
        'https://corsproxy.io/?${Uri.encodeComponent(targetUrl)}',
        // بديل مجاني
        'https://thingproxy.freeboard.io/fetch/$targetUrl',
        // AllOrigins خام (لا تستخدم /get لأنها JSON)
        'https://api.allorigins.win/raw?url=${Uri.encodeComponent(targetUrl)}',
      ];

      for (final p in proxies) {
        try {
          final resp = await http
              .get(Uri.parse(p), headers: _headers)
              .timeout(const Duration(seconds: 20));
          if (resp.statusCode == 200 && resp.body.isNotEmpty) {
            return resp.body;
          }
        } catch (_) {
          // جرّب اللي بعده
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Map<String, String> get _headers => const {
    'Accept': 'application/atom+xml, text/xml, application/xml, text/plain;q=0.9, */*;q=0.8',
    'User-Agent': 'SciSky-App/1.0 (+https://example.com)',
  };


  String? _extractFeedXml(String raw) {
    final s = raw.trim();

    // لو واضح إنه Atom feed سليم
    if (s.startsWith('<?xml') || s.contains('<feed')) {
      final startIdx = s.indexOf('<feed');
      final endIdx = s.lastIndexOf('</feed>');
      if (startIdx != -1 && endIdx != -1) {
        final endClose = endIdx + '</feed>'.length;
        return s.substring(startIdx, endClose);
      }
    }

    // fallback: رجّع زي ما هو (يمكن يكون سليم أصلاً)
    return s.isNotEmpty ? s : null;
  }
}









