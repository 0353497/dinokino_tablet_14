import 'package:dinokino_tablet/models/movie.dart';
import 'package:flutter/material.dart';

class DinoCard extends StatelessWidget {
  const DinoCard({super.key, required this.movie, required this.onTap});
  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
        ),
        padding: EdgeInsets.all(8),
        height: 250 - 12,
        width: 130,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(16),
                  child: Image.asset(
                    "assets/${movie.image}",
                    fit: BoxFit.cover,
                    height: 140,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
                ),
                Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Icon(
                        Icons.star,
                        size: 16,
                        color: i < movie.rating
                            ? Color(0xff00C8C4)
                            : Colors.grey,
                      ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (movie.isFavorite)
                    Icon(Icons.favorite, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
