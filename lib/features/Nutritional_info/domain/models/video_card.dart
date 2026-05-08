class VideoPost {
  final String userName;
  final String userAvatarUrl;
  final String videoThumbnailUrl;
  final String caption;
  final int likes;
  final int comments;
  final String timeAgo;

  const VideoPost({
    required this.userName,
    required this.userAvatarUrl,
    required this.videoThumbnailUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.timeAgo,
  });
}
