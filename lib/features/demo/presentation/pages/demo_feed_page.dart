import 'package:flutter/material.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/widgets/be_event_card.dart';
import 'package:benin_experience/core/widgets/be_story_ring.dart';
import 'package:benin_experience/core/widgets/be_ticket_card.dart';

/// Demo Feed Page - Benin Experience Design System
/// Démo du feed événements avec stories
class DemoFeedPage extends StatelessWidget {
  const DemoFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BEColors.background,
      appBar: AppBar(
        title: const Text('Bōken'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Stories horizontal bar
          SliverToBoxAdapter(
            child: BEStoriesFeedBar(
              stories: _getDemoStories(),
            ),
          ),
          
          // Divider
          const SliverToBoxAdapter(
            child: Divider(),
          ),
          
          // Feed items
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Mix events et tickets
                if (index % 3 == 0) {
                  return _buildTicketCard(index);
                } else {
                  return _buildEventCard(index);
                }
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(int index) {
    return BEEventCard(
      imageUrl: 'https://picsum.photos/seed/$index/800/600',
      title: 'Festival Jazz de Ouidah ${index + 1}',
      location: 'Ouidah, Atlantique',
      date: DateTime.now().add(Duration(days: index * 2)),
      likes: 124 + index * 10,
      comments: 18 + index * 2,
      isLiked: index % 3 == 0,
      organizerName: 'Festival Ouidah',
      organizerAvatar: 'https://picsum.photos/seed/org$index/100/100',
      onTap: () {
        print('Event card tapped: $index');
      },
      onLike: () {
        print('Like tapped: $index');
      },
      onComment: () {
        print('Comment tapped: $index');
      },
      onShare: () {
        print('Share tapped: $index');
      },
    );
  }

  Widget _buildTicketCard(int index) {
    return BETicketCard(
      eventTitle: 'Concert Angélique Kidjo',
      location: 'Stade de l\'Amitié, Cotonou',
      date: DateTime.now().add(const Duration(days: 30)),
      price: 15000 + (index * 5000),
      currency: 'FCFA',
      isForSale: true,
      isSold: false,
      qrCodeUrl: 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=ticket$index',
      sellerName: 'Jean-Pierre K.',
      category: 'VIP',
      onBuyTap: () {
        print('Buy tapped: $index');
      },
      onContactTap: () {
        print('Contact tapped: $index');
      },
      onTap: () {
        print('Ticket card tapped: $index');
      },
    );
  }

  List<StoryData> _getDemoStories() {
    return [
      StoryData(
        imageUrl: 'https://picsum.photos/seed/story1/200/200',
        label: 'Festival Jazz',
        viewed: false,
        isPremium: false,
        onTap: () => print('Story 1 tapped'),
      ),
      StoryData(
        imageUrl: 'https://picsum.photos/seed/story2/200/200',
        label: 'Vodoun Festival',
        viewed: false,
        isPremium: true,
        onTap: () => print('Story 2 tapped'),
      ),
      StoryData(
        imageUrl: 'https://picsum.photos/seed/story3/200/200',
        label: 'Concerts',
        viewed: true,
        onTap: () => print('Story 3 tapped'),
      ),
      StoryData(
        imageUrl: 'https://picsum.photos/seed/story4/200/200',
        label: 'Expositions',
        viewed: false,
        onTap: () => print('Story 4 tapped'),
      ),
      StoryData(
        imageUrl: 'https://picsum.photos/seed/story5/200/200',
        label: 'Théâtre',
        viewed: true,
        onTap: () => print('Story 5 tapped'),
      ),
    ];
  }
}
