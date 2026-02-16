import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final String contentKey;

  const LegalPage({
    super.key,
    required this.title,
    required this.contentKey,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    final String dummyText = """
1. Introduction
Welcome to AI Resume Pro. By using our app, you agree to these terms.

2. Usage
You may use the app to create and export resumes. You are responsible for the content you create.

3. Privacy
We respect your privacy. All data is stored locally on your device unless you use AI features which process data ephemerally.

4. Contact
For any questions, please contact support.
    """;

    return Scaffold(
      backgroundColor: c.backgroundStart,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: c.textPrimary)),
        iconTheme: IconThemeData(color: c.textPrimary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: c.cardBackgroundSolid,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: c.cardBorder),
            boxShadow: c.isDark ? [] : [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: Text(
            dummyText,
            style: TextStyle(color: c.textSecondary, fontSize: 14, height: 1.6),
          ),
        ),
      ),
    );
  }
}
