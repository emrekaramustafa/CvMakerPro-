import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home.title').tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('home.no_resumes').tr(),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                // Navigate to create resume
              },
              icon: const Icon(Icons.add),
              label: Text('home.create_new').tr(),
            ),
          ],
        ),
      ),
    );
  }
}
