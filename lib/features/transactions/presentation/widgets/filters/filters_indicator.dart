import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/theme/colors.dart';

class FiltersIndicator extends StatelessWidget {
  final bool visible;
  const FiltersIndicator({required this.visible, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4,
      top: 4,
      child: Container(
        width: 12,
        height: 12,
        decoration: const BoxDecoration(
          color: AppColors.secondaryAccent200,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
