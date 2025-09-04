import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import '../models/paper_model.dart';

class ArxivApiService {

  static const Map<String, String> categoryImages = {
    'cs.AI': 'https://upload.wikimedia.org/wikipedia/commons/6/6a/Artificial_Intelligence_logo_notext.svg',
    'physics': 'https://upload.wikimedia.org/wikipedia/commons/4/4c/Atom_icon.svg',
    'q-bio.BM': 'https://upload.wikimedia.org/wikipedia/commons/8/88/DNA_icon.svg',
    'math': 'https://upload.wikimedia.org/wikipedia/commons/d/d8/Math_icon.svg',
    'q-bio': 'https://upload.wikimedia.org/wikipedia/commons/7/70/Biology_icon.svg',
    'misc': 'https://upload.wikimedia.org/wikipedia/commons/6/65/Document_icon.svg',
  };

  Future<List<Paper>> fetchPapers({
    String? query,
    String? category,
    int start = 0,
    int maxResults = 20,
  }) async {
    final searchParts = <String>[];

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().replaceAll(' ', '+');
      searchParts.add('all:$q');
    } else {
      searchParts.add('all:*');
    }

    if (category != null && category.isNotEmpty) {
      searchParts.add('cat:$category');
    }

    final searchQuery = searchParts.join('+AND+');
    final url =
        'http://export.arxiv.org/api/query?search_query=$searchQuery&start=$start&max_results=$maxResults&sortBy=submittedDate&sortOrder=descending';

    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) {
        return [];
      }

      final doc = xml.XmlDocument.parse(resp.body);
      final entries = doc.findAllElements('entry');

      final result = <Paper>[];
      for (final e in entries) {
        final id = e.getElement('id')?.text ?? '';
        final title =
        (e.getElement('title')?.text ?? '').replaceAll('\n', ' ').trim();
        final summary = (e.getElement('summary')?.text ?? '')
            .replaceAll('\n', ' ')
            .trim();
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

        final firstCategory = cats.isNotEmpty ? cats.first : 'misc';

        final imageUrl = categoryImages.entries.firstWhere(
              (entry) => firstCategory.startsWith(entry.key),
          orElse: () => const MapEntry('misc',
              'https://upload.wikimedia.org/wikipedia/commons/6/65/Document_icon.svg'),
        ).value;

        result.add(Paper.fromApi(
          id: id,
          title: title,
          authors: authors.isEmpty ? ['Unknown'] : authors,
          summary: summary,
          publishedDate: published,
          categories: cats.isEmpty ? ['misc'] : cats,
          paperUrl: id,
          imageUrl: imageUrl,
        ));
      }
      return result;
    } catch (e) {
      print('❌ Error fetching papers: $e');
      return [];
    }
  }
}














