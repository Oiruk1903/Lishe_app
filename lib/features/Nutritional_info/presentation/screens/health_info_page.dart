import 'package:flutter/material.dart';
import 'package:lishe_app/features/Nutritional_info/presentation/screens/article_post_list.dart';
import 'package:lishe_app/features/Nutritional_info/presentation/screens/video_post_list.dart';
import 'package:lishe_app/features/chatbot/presentation/screens/chat_screen.dart';

class HealthInfoPage extends StatelessWidget {
  const HealthInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Health Info", style: TextStyle(fontSize: 20)),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [Tab(text: "Articles"), Tab(text: "Videos")],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [ArticlesPostList(), VideoPostList()],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Action for adding new content can be implemented here
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
          child: const Icon(Icons.comment_rounded, size: 30),
        ),
      ),
    );
  }
}
