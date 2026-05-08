import 'package:lishe_app/features/community/domain/models/challenge.dart';
import 'package:lishe_app/features/community/domain/repositories/challenge_repository.dart';

class ChallengeRepositoryImpl implements ChallengeRepository {
  @override
  Future<List<Challenge>> fetchChallenges() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    // TODO: implement fetchChallenges
    return [
      Challenge(
        title: 'weight loss Challenge',
        description:
            'Join us for a month-long fitness journey to improve your health and well-being.',
        imageUrl:
            'https://images.unsplash.com/photo-1745016191181-aa91c2fd23b6?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGNvbXVuaXR5JTIwY2hhbGxlbmdlfGVufDB8fDB8fHww',
      ),
      Challenge(
        title: 'Healthy Eating Challenge',
        description:
            'Commit to eating healthy for the next 21 days and transform your diet.',
        imageUrl:
            'https://images.unsplash.com/photo-1521747116042-5a810fda9664?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8aGVhbHRoeSUyMGVhdGluZ3xlbnwwfHwwfHx8MA==',
      ),
      Challenge(
        title: 'Mindfulness Meditation Challenge',
        description:
            'Practice mindfulness meditation daily for 15 minutes to reduce stress and improve focus.',
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8bWluZGZ1bG5lc3MlMjBtZWRpdGF0aW9ufGVufDB8fDB8fDA=',
      ),
      Challenge(
        title: 'Hydration Challenge',
        description:
            'Drink at least 2 liters of water daily for the next 14 days to stay hydrated.',
        imageUrl:
            'https://images.unsplash.com/photo-1593642532973-d31b6557fa68?w=700&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8aHlkcmF0aW9ufGVufDB8fDB8fDA=',
      ),
    ];
  }
}
