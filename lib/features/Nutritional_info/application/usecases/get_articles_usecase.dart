import 'package:lishe_app/features/Nutritional_info/domain/repositories/article_repository.dart';
import 'package:lishe_app/features/Nutritional_info/domain/models/article.dart';

class GetArticlesUseCase {
  final ArticleRepository repository;

  GetArticlesUseCase(this.repository);

  Future<List<Article>> call({
    String? dateOfBirth,
    String? gender,
    String? dietaryNeed,
  }) {
    return repository.getArticles(
      dateOfBirth: dateOfBirth,
      gender: gender,
      dietaryNeed: dietaryNeed,
    );
  }
}
