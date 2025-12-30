import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Skeleton extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const Skeleton({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      effect: PulseEffect(
        from: Colors.grey.shade300,
        to: Colors.grey.shade100,
      ),
      child: child,
    );
  }
}
