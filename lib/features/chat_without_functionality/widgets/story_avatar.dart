import 'package:flutter/material.dart';

class StoryAvatar extends StatelessWidget {

  final String storyImage;
  final String name;

  const StoryAvatar({
    super.key,

    required this.storyImage,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            // backgroundImage: NetworkImage(story.avatar),
            backgroundImage: NetworkImage(storyImage),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}