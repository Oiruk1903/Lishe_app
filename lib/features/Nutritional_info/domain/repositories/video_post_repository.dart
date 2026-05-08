import 'package:lishe_app/features/Nutritional_info/domain/models/video_card.dart';

abstract class VideoPostRepository {
  Future <List<VideoPost>> fetchVideoPosts();
}
