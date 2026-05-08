import 'package:lishe_app/features/Nutritional_info/domain/models/article.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles({
    String? dateOfBirth,
    String? gender,
    String? dietaryNeed,
  });
}
