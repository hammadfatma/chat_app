import 'package:chat_app/core/helpers/spacing.dart';
import 'package:flutter/material.dart';

class SayHello extends StatelessWidget {
  const SayHello({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "👋",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            verticalSpace(16),
            Text(
              "Say Hello",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
