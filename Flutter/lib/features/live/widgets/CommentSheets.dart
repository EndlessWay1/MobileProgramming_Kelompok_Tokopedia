import 'package:aplikasi_tokped/features/live/widgets/CommentSkeleton.dart';
import 'package:flutter/material.dart';

class Comment {
  final String username;
  final String text;
  const Comment(this.username, this.text);
}

class CommentsSheet extends StatefulWidget {
  final String reelId;
  final ScrollController scrollController;

  const CommentsSheet({
    super.key,
    required this.reelId,
    required this.scrollController,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _input = TextEditingController();
  late final Future<List<Comment>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = _fetchComments(); // temp
  }

// temp
  Future<List<Comment>> _fetchComments() async {
    await Future.delayed(const Duration(seconds: 2));
    return const [
      Comment('Alice', 'Nice product!'),
      Comment('Budi', 'Is this still in stock?'),
    ];
  }

// API temp
  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
  }


  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // lifts the input above the keyboard
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Comments',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _comments,
              builder: (context, snap) {
                if (snap.hasError) {
                  return const Center(child: Text('Failed to load comments'));
                }
                if (!snap.hasData) {
                  return CommentSkeleton(controller: widget.scrollController);
                }
                final items = snap.data!;
                if (items.isEmpty) {
                  return const Center(child: Text('No comments yet'));
                }
                return ListView.builder(
                  controller: widget.scrollController,
                  itemCount: items.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(items[i].username),
                    subtitle: Text(items[i].text),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(onPressed: _send, icon: const Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
