import 'package:chat_app/core/theming/styles.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Status',
        style: TextStyles.font30WhiteBold,
      ),
    );
  }
}
