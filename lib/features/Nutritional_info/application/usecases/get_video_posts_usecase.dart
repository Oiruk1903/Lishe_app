
import 'package:lishe_app/features/Nutritional_info/domain/models/video_card.dart';
import 'package:lishe_app/features/Nutritional_info/domain/repositories/video_post_repository.dart';

class GetVideoPostsUsecase {
  final VideoPostRepository _videoPostRepository;

  GetVideoPostsUsecase(this._videoPostRepository);

  Future<List<VideoPost>> call() async {
    return await _videoPostRepository.fetchVideoPosts();
  }
}