import 'package:lishe_app/features/Nutritional_info/domain/models/video_card.dart';
import 'package:lishe_app/features/Nutritional_info/domain/repositories/video_post_repository.dart';

class VideoRepositoryImpl implements VideoPostRepository {

  @override
  Future<List<VideoPost>> fetchVideoPosts() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate loading
    // TODO: implement fetchVideoPosts
    return [
      const VideoPost(
        userName: 'Halima Abdullah',
        userAvatarUrl: 'https://plus.unsplash.com/premium_photo-1664475543697-229156438e1e?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZG9jdG9yJTIwaW1hZ2VzfGVufDB8fDB8fHww',
        videoThumbnailUrl: 'https://plus.unsplash.com/premium_photo-1665203619621-b0fd7ccb6244?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8aGVhbHRoJTIwdmlkZW8lMjBpbWFnZXN8ZW58MHx8MHx8fDA%3D',
        caption: 'Staying fit and healthy with proper nutrition!',
        likes: 120,
        comments: 45,
        timeAgo: '2h ago',
      ),
      const VideoPost(
        userName: 'Jamal Khan',
        userAvatarUrl: 'https://images.unsplash.com/photo-1642975967602-653d378f3b5b?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZG9jdG9yJTIwaW1hZ2VzfGVufDB8fDB8fHww',
        videoThumbnailUrl: 'https://plus.unsplash.com/premium_photo-1665203553897-fe99bd907174?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8aGVhbHRoJTIwdmlkZW8lMjBpbWFnZXN8ZW58MHx8MHx8fDA%3D',
        caption: 'My favorite meal prep ideas for busy weeks!',
        likes: 95,
        comments: 20,
        timeAgo: '5h ago',
      ),
      const VideoPost(
        userName: 'John Doe',
        userAvatarUrl: 'https://plus.unsplash.com/premium_photo-1673351533766-fff5c388c7e5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDR8fHxlbnwwfHx8fHw%3D',
        videoThumbnailUrl: 'https://plus.unsplash.com/premium_photo-1723618898312-54269787cbe0?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGhlYWx0aCUyMHZpZGVvJTIwaW1hZ2VzfGVufDB8fDB8fHww',
        caption: 'Staying fit and healthy with proper nutrition!',
        likes: 120,
        comments: 45,
        timeAgo: '2h ago',
      ),
      const VideoPost(
        userName: 'Jane Smith',
        userAvatarUrl: 'https://plus.unsplash.com/premium_photo-1673351533766-fff5c388c7e5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDR8fHxlbnwwfHx8fHw%3D',
        videoThumbnailUrl: 'https://images.unsplash.com/photo-1747224317356-6dd1a4a078fd?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhlYWx0aCUyMHZpZGVvJTIwaW1hZ2VzfGVufDB8fDB8fHww',
        caption: 'My favorite meal prep ideas for busy weeks!',
        likes: 95,
        comments: 20,
        timeAgo: '5h ago',
      ),
    ];
  }
}