import 'package:flutter/foundation.dart';
import 'package:scisky_social_network/models/paper_model.dart';
import 'package:scisky_social_network/services/arxiv_api_service.dart';

enum PaperFetchStatus { initial, loading, success, error }

class PaperProvider with ChangeNotifier {
  final ArxivApiService _apiService = ArxivApiService();

  List<Paper> _papers = [];
  List<Paper> get papers => _papers;

  PaperFetchStatus _status = PaperFetchStatus.initial;
  PaperFetchStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  Future<void> fetchPapers({String query = 'AI', int maxResults = 10}) async {
    _status = PaperFetchStatus.loading;
    notifyListeners();

    try {
      _papers = await _apiService.searchPapers(searchQuery: query, maxResults: maxResults);
      _status = PaperFetchStatus.success;
    } on ArxivApiException catch (e) {
      _errorMessage = e.message;
      _status = PaperFetchStatus.error;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _status = PaperFetchStatus.error;
    }
    notifyListeners();
  }

  Future<void> fetchMorePapers({String query = 'AI'}) async {
    if (_status == PaperFetchStatus.loading) return; // Prevent multiple simultaneous fetches

    _status = PaperFetchStatus.loading; // Or a different status like 'loadingMore'
    notifyListeners();

  //   try {
  //     final newPapers = await _apiService.searchPapers(
  //       searchQuery: query,
  //       start: _papers.length, // Basic pagination: start after current papers
  //       maxResults: 10,
  //     );
  //     _papers.addAll(newPapers);
  //     _status = PaperFetchStatus.success;
  //   } on ArxivApiException catch (e) {
  //     _errorMessage = e.message;
  //     _status = PaperFetchStatus.error; // Or handle more gracefully for pagination
  //   } catch (e) {
  //     _errorMessage = 'An unexpected error occurred: ${e.toString()}';
  //     _status = PaperFetchStatus.error;
  //   }
  //   notifyListeners();
   }
}
