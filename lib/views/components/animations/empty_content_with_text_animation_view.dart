import 'package:flutter/material.dart';

class EmptyContentWithTextAnimationView extends StatelessWidget {
  const EmptyContentWithTextAnimationView({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white54),
          )
        ],
      ),
    );
  }
}
