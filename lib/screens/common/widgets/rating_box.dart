import 'package:flutter/material.dart';

class RatingDisplay extends StatelessWidget {
  final double rating;

  RatingDisplay({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.orange,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
            const Icon(
              Icons.star,
              size: 18,
              color: Colors.orange,
            )
          ],
        ),
      ),
    );
  }
}