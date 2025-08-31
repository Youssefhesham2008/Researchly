import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scisky_social_network/utils/app_theme.dart';
import 'package:scisky_social_network/providers/paper_provider.dart';
import 'package:scisky_social_network/models/paper_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String selectedCategory = "cs.AI"; // Default category

  @override
  void initState() {
    super.initState();
    // Fetch default category papers on load
    Future.microtask(() {
      Provider.of<PaperProvider>(context, listen: false)
          .fetchPapers(query: "cat:$selectedCategory", maxResults: 10);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// ---------- PAPERS TAB ----------
  Widget _buildPapersTab() {
    return Column(
      children: [
        // Category Filter Dropdown
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: selectedCategory,
            items: const [
              DropdownMenuItem(value: "cs.AI", child: Text("Artificial Intelligence")),
              DropdownMenuItem(value: "stat.ML", child: Text("Machine Learning")),
              DropdownMenuItem(value: "physics.gen-ph", child: Text("Physics")),
              DropdownMenuItem(value: "math", child: Text("Mathematics")),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedCategory = value);
                Provider.of<PaperProvider>(context, listen: false)
                    .fetchPapers(query: "cat:$value", maxResults: 10);
              }
            },
          ),
        ),

        // Paper List
        Expanded(
          child: Consumer<PaperProvider>(
            builder: (context, paperProvider, child) {
              switch (paperProvider.status) {
                case PaperFetchStatus.loading:
                  return const Center(child: CircularProgressIndicator());

                case PaperFetchStatus.error:
                  return Center(
                    child: Text(
                      "Error: ${paperProvider.errorMessage}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );

                case PaperFetchStatus.success:
                  if (paperProvider.papers.isEmpty) {
                    return const Center(child: Text("No papers found."));
                  }
                  return ListView.builder(
                    itemCount: paperProvider.papers.length,
                    itemBuilder: (context, index) {
                      final Paper paper = paperProvider.papers[index];
                      return _buildPaperCard(paper);
                    },
                  );

                default:
                  return const Center(child: Text("Welcome to SciSky!"));
              }
            },
          ),
        ),
      ],
    );
  }

  /// ---------- PAPER CARD ----------
  Widget _buildPaperCard(Paper paper) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              paper.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),

            // Authors
            Wrap(
              spacing: 6,
              runSpacing: -8,
              children: paper.authors
                  .map((a) => Chip(
                label: Text(a),
                backgroundColor: AppTheme.accentColor.withOpacity(0.1),
              ))
                  .toList(),
            ),
            const SizedBox(height: 8),

            // Summary
            Text(
              paper.summary,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppTheme.subtleTextColor),
            ),
            const SizedBox(height: 8),

            // Date + Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Published: ${paper.publishedDate.toLocal().toString().split(' ')[0]}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Wrap(
                  spacing: 6,
                  children: paper.categories
                      .map((c) => Chip(
                    label: Text(c),
                    backgroundColor: Colors.blue.shade50,
                  ))
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- MAIN BUILD ----------
  @override
  Widget build(BuildContext context) {
    debugPrint("HomeScreen: build method called");
    return Scaffold(
      appBar: AppBar(
        title: const Text('SciSky'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildPapersTab(), // Papers tab
          const Center(
              child: Text('Forums Tab Content',
                  style: TextStyle(color: AppTheme.textColor))),
          const Center(
              child: Text('Saved Tab Content',
                  style: TextStyle(color: AppTheme.textColor))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Papers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: 'Forums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
