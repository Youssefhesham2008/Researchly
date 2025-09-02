import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../models/forum_post_model.dart';
import '../../providers/forum_provider.dart';
import '../../providers/auth_provider.dart';

class ForumPostScreen extends StatefulWidget {
  static const routeName = '/forum-post';
  const ForumPostScreen({super.key});

  @override
  State<ForumPostScreen> createState() => _ForumPostScreenState();
}

class _ForumPostScreenState extends State<ForumPostScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as ForumPost;

    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.content),
            const SizedBox(height: 12),
            Text('${'by'.tr()} ${post.author}', style: const TextStyle(color: Colors.white70)),
            const Divider(height: 24),
            Text('comments'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.separated(
                itemCount: post.comments.length,
                itemBuilder: (_, i) {
                  final c = post.comments[i];
                  return ListTile(
                    title: Text(c.text),
                    subtitle: Text('${c.author} • ${c.createdAt.toLocal()}'),
                  );
                },
                separatorBuilder: (_, __) => const Divider(height: 1),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'write_comment'.tr()),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    final user = context.read<AuthProvider>().username ?? 'Guest';
                    await context.read<ForumProvider>().addComment(post.id, user, text);
                    if (!mounted) return;
                    setState(() {
                      _controller.clear();
                    });
                  },
                  child: Text('post'.tr()),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}





