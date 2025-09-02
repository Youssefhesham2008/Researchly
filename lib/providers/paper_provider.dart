import 'package:flutter/material.dart';
import '../models/paper_model.dart';
import '../services/arxiv_api_service.dart';
import '../utils/prefs_helper.dart';

class PaperProvider extends ChangeNotifier {
  final _api = ArxivApiService();

  List<Paper> _papers = [];
  bool _loading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategory;

  final List<Paper> _saved = [];

  List<Paper> get papers => _papers;
  bool get loading => _loading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;

  List<Paper> get savedPapers => List.unmodifiable(_saved);

  Future<void> loadSaved() async {
    final list = await PrefsHelper.loadPapersJsonList();
    _saved
      ..clear()
      ..addAll(list.map((e) => Paper.fromJson(e)));
    notifyListeners();
  }

  Future<void> _saveSavedToPrefs() async {
    await PrefsHelper.savePapersJsonList(_saved.map((e) => e.toJson()).toList());
  }

  Future<void> fetch({bool reset = true}) async {
    try {
      _loading = true;
      _error = null;
      if (reset) _papers = [];

      final result = await _api.fetchPapers(
        query: _searchQuery.isEmpty ? null : _searchQuery,
        category: _selectedCategory,
        start: 0,
        maxResults: 20,
      );
      _papers = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  void setCategory(String? cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  Future<void> search() async {
    await fetch(reset: true);
  }

  bool isSaved(Paper p) => _saved.any((e) => e.id == p.id);

  Future<void> toggleSave(Paper p) async {
    final idx = _saved.indexWhere((e) => e.id == p.id);
    if (idx >= 0) {
      _saved.removeAt(idx);
    } else {
      _saved.add(p);
    }
    await _saveSavedToPrefs();
    notifyListeners();
  }
}



