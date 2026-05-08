// presentation/challenges_screen.dart
import 'package:flutter/material.dart';

import '../../application/usecases/get_challenges_usecases.dart';
import '../../data/challenge_repository_impl.dart';
import '../../domain/models/challenge.dart';
import '../widgets/challenge_card.dart';


class ChallengesScreen extends StatelessWidget {
  final useCase = FetchChallengesUseCase(ChallengeRepositoryImpl());

  ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Challenge>>(
      future: useCase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Error loading challenges'));
        }

        final challenges = snapshot.data!;
        final progressCard = Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Image.network('https://media.istockphoto.com/id/1951711154/photo/photo-of-young-women-in-winter-wear-standing-on-yellow-background-stock-photo.webp?a=1&b=1&s=612x612&w=0&k=20&c=Zk8Mki_hxt_mE48BxC-89QltHQHm6RopjJt1U73G5E0=', height: 80),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Celebrate Your Wins', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Share your achievements with friends and family on social media.',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ), child: Text('Share')),
            ],
          ),
        );

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Center(child: Text('Community Hub', style: Theme.of(context).textTheme.headlineSmall)),
              ),
              sectionTitle('Challenges'),
              horizontalList(challenges.sublist(0, 4)),
              sectionTitle('Competitions'),
              horizontalList(challenges.sublist(2)),
              sectionTitle('Share Your Progress'),
              progressCard,
            ],
          ),
        );
      },
    );
  }

  Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }

  Widget horizontalList(List<Challenge> items) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => ChallengeCard(challenge: items[index]),
      ),
    );
  }
}
