import 'package:flutter/material.dart';
import '../main.dart';

class ScenarioDetailScreen extends StatefulWidget {
  final ScenarioItem scenario;

  const ScenarioDetailScreen({super.key, required this.scenario});

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenario.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Öğrenme Modları',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildModeCard(
              'Dinleme',
              'Diyaloğu dinleyerek öğren',
              Icons.headphones,
              () {
                // TODO: Dinleme moduna git
              },
            ),
            const SizedBox(height: 16),
            _buildModeCard(
              'Konuşma',
              'Konuşarak pratik yap',
              Icons.mic,
              () {
                // TODO: Konuşma moduna git
              },
            ),
            const SizedBox(height: 16),
            _buildModeCard(
              'Yazma',
              'Yazarak öğren',
              Icons.edit,
              () {
                // TODO: Yazma moduna git
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(description),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
} 