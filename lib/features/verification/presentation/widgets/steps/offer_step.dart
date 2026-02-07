
import 'package:flutter/material.dart';

class OfferStep extends StatelessWidget {
  const OfferStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Votre offre',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Décrivez ce que vous proposez aux visiteurs.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Catégorie',
          ),
          items: const [
            DropdownMenuItem(value: 'hotel', child: Text('Hôtel')),
            DropdownMenuItem(value: 'restaurant', child: Text('Restaurant')),
            DropdownMenuItem(value: 'tour_guide', child: Text('Guide touristique')),
            DropdownMenuItem(value: 'cultural_site', child: Text('Site culturel')),
            DropdownMenuItem(value: 'event_organizer', child: Text('Organisateur d\'événements')),
          ],
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        TextFormField(
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description de votre activité',
            hintText: 'Décrivez l\'expérience unique que vous offrez...',
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            'Français',
            'English',
            'Fon',
            'Yoruba',
          ].map((lang) => FilterChip(
            label: Text(lang),
            onSelected: (selected) {},
          )).toList(),
        ),
      ],
    );
  }
}
