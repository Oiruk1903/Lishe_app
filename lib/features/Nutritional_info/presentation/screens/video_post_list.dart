import 'package:flutter/material.dart';

import '../../application/usecases/get_video_posts_usecase.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../widgets/video_post_card.dart';

class VideoPostList extends StatelessWidget {
  final useCase = GetVideoPostsUsecase(VideoRepositoryImpl());

  VideoPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: useCase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load videos'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No videos found'));
        }

        final videoPosts = snapshot.data!;

        return ListView.builder(
          itemCount: videoPosts.length,
          itemBuilder: (context, index) => VideoPostCard(
            videoPost: videoPosts[index],
          ),
        );
      },
    );
  }
}
