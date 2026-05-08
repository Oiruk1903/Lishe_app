import 'package:flutter/material.dart';
import 'package:lishe_app/features/Nutritional_info/domain/models/video_card.dart';

class VideoPostCard extends StatelessWidget {
  final VideoPost videoPost;
  const VideoPostCard({super.key, required this.videoPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(videoPost.userAvatarUrl),
              ),
              const SizedBox(width: 10),
              Text(
                videoPost.userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                videoPost.timeAgo,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              )
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              videoPost.videoThumbnailUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            videoPost.caption,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite_border, color: Colors.grey[600], size: 20),
              const SizedBox(width: 4),
              Text('${videoPost.likes}'),
              const SizedBox(width: 16),
              Icon(Icons.comment, color: Colors.grey[600], size: 20),
              const SizedBox(width: 4),
              Text('${videoPost.comments}'),
            ],
          )
        ],
      ),
    );
  }
}