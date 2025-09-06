import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../providers/forum_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/forum_post_card.dart';

class ForumsTab extends StatelessWidget {
  const ForumsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final forum = context.watch<ForumProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: forum.posts.isEmpty
          ? Center(child: Text('no_papers'.tr())) // رسالة افتراضية
          : ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (_, i) => ForumPostCard(post: forum.posts[i]),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: forum.posts.length,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'create_post'.tr(),
        onPressed: () async {
          final post = await showDialog<_NewPostResult>(
            context: context,
            builder: (ctx) => const _NewPostDialog(),
          );
          if (post != null && context.mounted) {
            await context.read<ForumProvider>().createPost(post.title, post.content, auth.username ?? 'Guest');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NewPostDialog extends StatefulWidget {
  const _NewPostDialog();

  @override
  State<_NewPostDialog> createState() => _NewPostDialogState();
}

class _NewPostDialogState extends State<_NewPostDialog> {
  final t = TextEditingController();
  final c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('create_post'.tr()),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: t, decoration: const InputDecoration(hintText: 'Title')),
            const SizedBox(height: 8),
            TextField(
              controller: c,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Content'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _NewPostResult(t.text.trim(), c.text.trim()));
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _NewPostResult {
  final String title;
  final String content;
  _NewPostResult(this.title, this.content);
}




