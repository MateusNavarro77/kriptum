import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  const ActionButton({super.key, required this.label, this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(onPressed: onPressed, icon: Icon(icon)),
        Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
