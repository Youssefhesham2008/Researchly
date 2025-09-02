import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/paper_model.dart';
import '../../providers/paper_provider.dart';
import '../../services/arxiv_api_service.dart';

class PapersTab extends StatefulWidget {
  const PapersTab({super.key});

  @override
  State<PapersTab> createState() => _PapersTabState();
}

class _PapersTabState extends State<PapersTab> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory;
  bool isLoading = false;
  List<Paper> papers = [];

  final apiService = ArxivApiService();


  final Map<String, String> categoryImages = {
    'AI': 'https://cdn-icons-png.flaticon.com/512/4712/4712109.png',
    'Physics': 'https://cdn-icons-png.flaticon.com/512/616/616655.png',
    'Medicine': 'https://cdn-icons-png.flaticon.com/512/2966/2966489.png',
    'Math': 'https://cdn-icons-png.flaticon.com/512/2921/2921222.png',
    'Biology': 'https://cdn-icons-png.flaticon.com/512/616/616408.png',
    'misc': 'https://cdn-icons-png.flaticon.com/512/1829/1829586.png',
  };

  @override
  void initState() {
    super.initState();
    _fetchLatestPapers();
  }

  Future<void> _fetchLatestPapers() async {
    setState(() => isLoading = true);
    final result = await apiService.fetchLatestPapers();
    setState(() {
      papers = result;
      isLoading = false;
    });
  }

  Future<void> _searchPapers() async {
    setState(() => isLoading = true);
    final result = await apiService.fetchPapers(
      query: _searchController.text,
      category: selectedCategory,
    );
    setState(() {
      papers = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasFilter = selectedCategory != null || _searchController.text.isNotEmpty;

    return Column(
      children: [
        // 🔍 Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search papers...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.blueAccent),
                onPressed: _searchPapers,
              ),
            ],
          ),
        ),

        // 📂 Category Filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['AI', 'Physics', 'Medicine', 'Math', 'Biology']
                .map((cat) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(cat),
                selected: selectedCategory == cat,
                onSelected: (val) {
                  setState(() {
                    selectedCategory = val ? cat : null;
                  });
                  _searchPapers();
                },
              ),
            ))
                .toList(),
          ),
        ),

        const SizedBox(height: 10),

        // 📄 Papers List
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : papers.isEmpty
              ? const Center(child: Text("No papers found"))
              : ListView.builder(
            itemCount: papers.length,
            itemBuilder: (context, index) {
              final paper = papers[index];
              final imageUrl = categoryImages[paper.categories.first] ??
                  categoryImages['misc']!;

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🖼️ صورة لو مفيش فلتر
                      if (!hasFilter)
                        Center(
                          child: Image.network(
                            imageUrl,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      const SizedBox(height: 10),

                      // 📌 Title
                      Text(
                        paper.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 👨‍🔬 Authors
                      Text(
                        "Authors: ${paper.authors.join(', ')}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // 📅 Published Date
                      Text(
                        "Published: ${paper.publishedDate.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 6),

                      // 📝 Summary
                      Text(
                        paper.summary,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 6),

                      // 🔗 Button to open details
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Navigate to details screen
                          },
                          child: const Text("Read More"),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}








