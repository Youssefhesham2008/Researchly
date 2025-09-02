import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/paper_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/forum_provider.dart';
import '../forum_post/forum_post_screen.dart';

class PaperDetailsScreen extends StatelessWidget {
  static const routeName = '/paper-details';
  const PaperDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paper = ModalRoute.of(context)!.settings.arguments as Paper;

    return Scaffold(
      appBar: AppBar(title: Text('details'.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(paper.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('${'by'.tr()} ${paper.authors.join(', ')}', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: -8,
              children: paper.categories.take(6).map((c) => Chip(label: Text(c))).toList(),
            ),
            const SizedBox(height: 16),
            Text(paper.summary),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final url = Uri.parse(paper.paperUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text('open_full_paper'.tr()),
                ),
                const SizedBox(width: 12),
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






