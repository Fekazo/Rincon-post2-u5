import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/screens/posts_screen.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Lab U5',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF065A82),
        useMaterial3: true,
      ),
      home: const PostsScreen(),
    );
  }
}