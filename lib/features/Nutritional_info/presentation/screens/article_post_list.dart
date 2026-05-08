import 'package:flutter/material.dart';

import '../../application/usecases/get_articles_usecase.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../widgets/article_card.dart';

class ArticlesPostList extends StatelessWidget {
  final useCase = GetArticlesUseCase(ArticleRepositoryImpl());

  ArticlesPostList({super.key});

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

        final articlesPosts = snapshot.data!;

        return ListView.builder(
          itemCount: articlesPosts.length,
          itemBuilder: (context, index) => ArticleCard(
            article: articlesPosts[index],
          ),
        );
      },
    );
  }
}
