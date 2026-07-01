import 'package:flutter/material.dart';

class LoginPromptCard extends StatelessWidget {
  const LoginPromptCard({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onLogin,
    this.padding = const EdgeInsets.all(16),
    this.centered = false,
  });

  final String message;
  final String buttonText;
  final VoidCallback onLogin;
  final EdgeInsetsGeometry padding;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final card = _LoginPromptCardContent(
      message: message,
      buttonText: buttonText,
      onLogin: onLogin,
    );

    if (centered) {
      return Padding(padding: padding, child: Center(child: card));
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      children: [card],
    );
  }
}

class _LoginPromptCardContent extends StatelessWidget {
  const _LoginPromptCardContent({
    required this.message,
    required this.buttonText,
    required this.onLogin,
  });

  final String message;
  final String buttonText;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(message, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onLogin,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
