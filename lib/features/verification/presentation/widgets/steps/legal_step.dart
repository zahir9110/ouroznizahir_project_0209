
import 'package:flutter/material.dart';

class LegalStep extends StatelessWidget {
  const LegalStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Votre entreprise',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Informations légales de votre activité.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Type d\'entreprise',
          ),
          items: const [
            DropdownMenuItem(value: 'individual', child: Text('Individuel')),
            DropdownMenuItem(value: 'llc', child: Text('SARL')),
            DropdownMenuItem(value: 'corporation', child: Text('SA')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Nom de l\'entreprise',
            prefixIcon: Icon(Icons.business),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Numéro RCCM',
            prefixIcon: Icon(Icons.numbers),
          ),
        ),
      ],
    );
  }
}