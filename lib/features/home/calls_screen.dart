import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Calls',
        style: TextStyles.font30WhiteBold,
      ),
    );
  }
}
