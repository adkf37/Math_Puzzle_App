import 'package:flutter/material.dart';

import '../../app/app_scope.dart';
import '../../core/models/puzzle_definition.dart';

class ContentPreviewScreen extends StatefulWidget {
  const ContentPreviewScreen({super.key});

  @override
  State<ContentPreviewScreen> createState() => _ContentPreviewScreenState();
}

class _ContentPreviewScreenState extends State<ContentPreviewScreen> {
  Future<List<PuzzleDefinition>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= AppScope.of(context).contentRepository.loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Preview (Dev)')),
      body: FutureBuilder<List<PuzzleDefinition>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snapshot.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return Card(
                child: ListTile(
                  title: Text(item.id),
                  subtitle: Text('${item.type.name} / ${item.difficulty.name}'),
                  trailing: Text('hints: ${item.hints.length}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
