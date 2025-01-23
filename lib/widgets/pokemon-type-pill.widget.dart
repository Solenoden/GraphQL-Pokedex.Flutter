import 'package:flutter/material.dart';

import '../models/pokemon-type.model.dart';

class PokemonTypePill extends StatelessWidget {
  final PokemonType type;
  final bool isSelected;
  final Function()? onTap;

  const PokemonTypePill(this.type, {super.key, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: type.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black45 : type.color,
            width: 3,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          type.name.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
