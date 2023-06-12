import 'package:flutter/material.dart';
import 'package:rick_morty_flutter_app/api/api.dart';

class PersonajeCard extends StatelessWidget {
  const PersonajeCard({
    required this.personaje,
    required this.isFavourite,
    required this.onTap,
    this.onChangeFavourite,
    super.key,
    required this.heroTag,
  });

  final Personaje personaje;
  final bool isFavourite;
  final VoidCallback onTap;
  final VoidCallback? onChangeFavourite;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[300],
        ),
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 450,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    personaje.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress != null) {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 8,
                          ),
                        );
                      } else {
                        return child;
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      personaje.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (onChangeFavourite != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: onChangeFavourite,
                        icon: Icon(
                          isFavourite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
