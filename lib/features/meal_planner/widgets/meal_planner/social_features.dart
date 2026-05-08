import 'package:flutter/material.dart';
import 'package:lishe_app/features/meal_planner/models/meal.dart';

class SocialFeaturesPanel extends StatelessWidget {
  final DateTime selectedDate;
  final Function(Meal) onShareMeal;

  const SocialFeaturesPanel({
    super.key,
    required this.selectedDate,
    required this.onShareMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Social Features',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCommunitySection(),
          const SizedBox(height: 16),
          _buildChallengesSection(),
          const SizedBox(height: 16),
          _buildAchievementsSection(),
        ],
      ),
    );
  }

  Widget _buildCommunitySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Community',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildCommunityItem(
              'Share Your Meal',
              'Share your healthy meals with the community',
              Icons.share,
            ),
            _buildCommunityItem(
              'Join Groups',
              'Connect with like-minded health enthusiasts',
              Icons.group,
            ),
            _buildCommunityItem(
              'Follow Friends',
              'Stay motivated with your friends\' progress',
              Icons.people,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Active Challenges',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildChallengeItem(
              '7-Day Clean Eating',
              '3 days remaining',
              Icons.emoji_events,
              Colors.amber,
            ),
            _buildChallengeItem(
              'Weekly Workout',
              '5 days remaining',
              Icons.fitness_center,
              Colors.green,
            ),
            _buildChallengeItem(
              'Hydration Goal',
              '2 days remaining',
              Icons.water_drop,
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Achievements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildAchievementItem(
              'Meal Planning Pro',
              'Planned 30 days of meals',
              Icons.star,
              Colors.amber,
            ),
            _buildAchievementItem(
              'Healthy Eater',
              'Completed 7 days of healthy eating',
              Icons.restaurant,
              Colors.green,
            ),
            _buildAchievementItem(
              'Community Star',
              'Shared 10 meals with the community',
              Icons.people,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeItem(
    String title,
    String timeRemaining,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  timeRemaining,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified, color: color),
        ],
      ),
    );
  }
} 