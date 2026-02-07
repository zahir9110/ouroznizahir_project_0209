import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Mes Billets (A venir)", style: TextStyle(color: AppColors.textPrimary)));
  }
}
