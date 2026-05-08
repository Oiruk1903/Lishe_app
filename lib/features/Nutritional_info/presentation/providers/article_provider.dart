import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lishe_app/features/Nutritional_info/application/usecases/get_articles_usecase.dart';
import 'package:lishe_app/features/Nutritional_info/data/repositories/article_repository_impl.dart';

final articleRepositoryProvider = Provider((ref) => ArticleRepositoryImpl());

final getArticleUseCaseProvider =
    Provider((ref) => GetArticlesUseCase(ref.watch(articleRepositoryProvider)));

final articleProvider = FutureProvider((ref) {
  final usecase = ref.watch(getArticleUseCaseProvider);
  return usecase();
});
