import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import '../models/paper_model.dart';
import '../providers/paper_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/forum_provider.dart';
import '../screens/paper_details/paper_details_screen.dart';
import '../screens/forum_post/forum_post_screen.dart';

class PaperCard extends StatelessWidget {
  final Paper paper;

  const PaperCard({
    super.key,
    required this.paper,
  });

  @override
  Widget build(BuildContext context) {
    final saved = context.select<PaperProvider, bool>((p) => p.isSaved(paper));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (paper.imageUrl != null) _PaperImage(path: paper.imageUrl!),

            if (paper.imageUrl != null) const SizedBox(height: 8),

            Text(
              paper.title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            Text(
              '${'by'.tr()} ${paper.authors.join(', ')}',
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
            ),
            const SizedBox(height: 8),

            Text(
              paper.summary.length > 200 ? '${paper.summary.substring(0, 200)}...' : paper.summary,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 6,
              runSpacing: -8,
              children: paper.categories.take(4).map((c) {
                return Chip(label: Text(c, style: const TextStyle(fontSize: 11)));
              }).toList(),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, PaperDetailsScreen.routeName, arguments: paper);
                  },
                  icon: const Icon(Icons.info_outline),
                  label: Text('details'.tr()),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(paper.paperUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text('open_full_paper'.tr()),
                ),
                const Spacer(),
                IconButton(
                  tooltip: saved ? 'unsave'.tr() : 'save'.tr(),
                  onPressed: () => context.read<PaperProvider>().toggleSave(paper),
                  icon: Icon(saved ? Icons.bookmark : Icons.bookmark_outline),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: () async {
                    final auth = context.read<AuthProvider>();
                    final forum = context.read<ForumProvider>();
                    final post = await forum.createOrGetPostForPaper(
                      paperId: paper.id,
                      title: paper.title,
                      content: paper.summary.substring(0, paper.summary.length > 280 ? 280 : paper.summary.length),
                      author: auth.username ?? 'Guest',
                    );
                    if (!context.mounted) return;
                    Navigator.pushNamed(context, ForumPostScreen.routeName, arguments: post);
                  },
                  icon: const Icon(Icons.forum),
                  label: Text('discuss_in_forum'.tr()),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// ويدجت صغيرة تعرض الصورة من assets أو من النت.
/// إحنا هنا هنستعمل paths للـ assets (زي: assets/images/ai.jpg).
class _PaperImage extends StatelessWidget {
  final String path;
  const _PaperImage({required this.path});

  bool get _isNetwork => path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    final imageWidget = _isNetwork
        ? Image.network(
      path,
      height: 140,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => _fallback(),
    )
         :Image.asset(
      path, // Example: assets/images/ai.jpg
      height: 140,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => _fallback(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: imageWidget,
      ),
    );
  }

  Widget _fallback() {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.grey[800],
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image, color: Colors.white70, size: 40),
    );
  }
}



