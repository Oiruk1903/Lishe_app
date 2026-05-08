import 'package:lishe_app/features/Nutritional_info/domain/repositories/article_repository.dart';
import 'package:lishe_app/features/Nutritional_info/domain/models/article.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  @override
  Future<List<Article>> getArticles(
      {String? dateOfBirth, String? gender, String? dietaryNeed}) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate loading
    // TODO: implement getArticles
    return [
      Article(
        title: 'Healthy Eating Habits for Children',
        subtitle: 'Learn how to create balanced meals for your kids.',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1675808577247-2281dc17147a?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8aGVhbHRofGVufDB8fDB8fHww',
        category: 'Nutrition',
      ),
      Article(
        title: 'Understanding Nutritional Needs for Women',
        subtitle: 'Discover the specific dietary requirements for women.',
        imageUrl: 'https://media.istockphoto.com/id/2214959349/photo/couple-examining-medicine-labels-in-modern-kitchen.webp?a=1&b=1&s=612x612&w=0&k=20&c=JMQwuKsu7Y-6bVL38rrVolUBYmZs08jBlGbcX7WiRiA=',
        category: 'Nutrition',
      ),
      Article(
          title: 'Dietary Tips for Men’s Health',
          subtitle: 'Explore essential nutrients for men’s well-being.',
          imageUrl: 'https://plus.unsplash.com/premium_photo-1666264200751-8a013663a89b?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWVuJTIwaGVhbHRofGVufDB8fDB8fHww',
          category: 'health'),
      Article(
          title: 'Managing Diabetes Through Diet',
          subtitle:
              'Learn how to control blood sugar levels with a balanced diet.',
          imageUrl: 'https://images.unsplash.com/photo-1685061981570-f2b0e045d3ef?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8TWFuYWdpbmclMjBEaWFiZXRlc3xlbnwwfHwwfHx8MA%3D%3D',
          category: 'health'),
          Article(
        title: 'Understanding Nutritional Needs for Women',
        subtitle: 'Discover the specific dietary requirements for women.',
        imageUrl: 'https://media.istockphoto.com/id/2214959349/photo/couple-examining-medicine-labels-in-modern-kitchen.webp?a=1&b=1&s=612x612&w=0&k=20&c=JMQwuKsu7Y-6bVL38rrVolUBYmZs08jBlGbcX7WiRiA=',
        category: 'Nutrition',
      ),
      Article(
        title: 'Healthy Eating Habits for Children',
        subtitle: 'Learn how to create balanced meals for your kids.',
        imageUrl: 'https://plus.unsplash.com/premium_photo-1675808577247-2281dc17147a?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8aGVhbHRofGVufDB8fDB8fHww',
        category: 'Nutrition',
      ),
    ];
  }
}
