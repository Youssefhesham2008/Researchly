import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/paper_model.dart';
import '../../services/arxiv_api_service.dart';
import '../../mock/mock_papers.dart';
import '../../widgets/paper_card.dart';
import '../../providers/paper_provider.dart';

class PapersTab extends StatefulWidget {
  const PapersTab({super.key});

  @override
  State<PapersTab> createState() => _PapersTabState();
}

class _PapersTabState extends State<PapersTab> {
  String? selectedCategory;
  late Future<List<Paper>> papersFuture;

  final Map<String, String> categoryLabels = {
    'AI': 'Artificial Intelligence',
    'Physics': 'Physics',
    'Math': 'Mathematics',
    'Biology': 'Biology',
    'Medicine': 'Medicine',
  };

  @override
  void initState() {
    super.initState();
    papersFuture = _loadPapers();
  }

  Future<List<Paper>> _loadPapers() async {
    try {
      final api = ArxivApiService();
      final papers = await api.fetchPapers(category: selectedCategory);

      if (papers.isEmpty) return mockPapers;

      return papers.map((p) {
        final hasFilter = selectedCategory != null && selectedCategory != 'all';
        if (!hasFilter) {
          // مفيش فلتر → نزود الصور حسب أول كاتيجوري
          final imageUrl =
          _getImageForCategory(p.categories.isNotEmpty ? p.categories.first : "");
          return p.copyWith(imageUrl: imageUrl);
        }
        // فلتر متفعل → منغير صور
        return p.copyWith(imageUrl: null);
      }).toList();
    } catch (_) {
      return mockPapers;
    }
  }

  String? _getImageForCategory(String category) {
    if (category.contains("cs.AI")) {
      return "assets/images/ai.jpg";
    } else if (category.contains("physics")) {
      return "assets/images/physics.jpg";
    } else if (category.contains("math")) {
      return "assets/images/math.jpg";
    } else if (category.contains("q-bio.BM") || category.contains("medicine")) {
      return "assets/images/medicine.jpg";
    } else if (category.contains("q-bio")) {
      return "assets/images/biology.jpg";
    }
    return null;
  }



  void _onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category;
      papersFuture = _loadPapers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFilter = selectedCategory != null && selectedCategory != 'all';

    return Column(
      children: [
        // ===== الفلاتر (ChoiceChips) =====
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ChoiceChip(
                label: Text("All".tr()),
                selected: selectedCategory == null || selectedCategory == 'all',
                onSelected: (_) => _onCategorySelected('all'),
              ),
              const SizedBox(width: 6),
              ...categoryLabels.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(entry.value),
                    selected: selectedCategory == entry.key,
                    onSelected: (_) => _onCategorySelected(entry.key),
                  ),
                );
              }),
            ],
          ),
        ),

        // ===== قائمة الأوراق =====
        Expanded(
          child: FutureBuilder<List<Paper>>(
            future: papersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading papers"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No papers found"));
              }

              final papers = snapshot.data!;
              return ListView.builder(
                itemCount: papers.length,
                itemBuilder: (context, index) {
                  final paper = papers[index];
                  return PaperCard(paper: paper);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}












