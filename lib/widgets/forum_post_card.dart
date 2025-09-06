
import 'package:flutter/material.dart';
import '../models/forum_post_model.dart';
import '../screens/forum_post/forum_post_screen.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPost post;
  const ForumPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          post.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.comment, size: 16),
            const SizedBox(width: 4),
            Text(post.comments.length.toString()),
          ],
        ),
        onTap: () => Navigator.pushNamed(context, ForumPostScreen.routeName, arguments: post),
      ),
    );
  }
}


