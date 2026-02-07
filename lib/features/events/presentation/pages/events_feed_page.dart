import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/events_feed_bloc.dart';
import '../bloc/events_feed_event.dart';
import '../bloc/events_feed_state.dart';
import '../widgets/contextual_header.dart';
import '../widgets/spontaneous_event_card.dart';
import '../widgets/cultural_gem_card.dart';
import '../widgets/event_list_tile.dart';

/// Page principale du feed événements enrichis par IA
class EventsFeedPage extends StatelessWidget {
  const EventsFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EventsFeedBloc>()
        ..add(const LoadPersonalizedFeed(
          userId: 'demo_user', // TODO: Remplacer par FirebaseAuth.currentUser
          userLocation: GeoPoint(6.3703, 2.3912), // Cotonou par défaut
        ))
        ..add(const LoadCulturalGems('demo_user'))
        ..add(const LoadSpontaneousEvents(
          GeoPoint(6.3703, 2.3912),
        )),
      child: const _EventsFeedView(),
    );
  }
}

class _EventsFeedView extends StatelessWidget {
  const _EventsFeedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<EventsFeedBloc>().add(RefreshFeed());
          // Recharger les données
          context.read<EventsFeedBloc>().add(const LoadPersonalizedFeed(
                userId: 'demo_user',
                userLocation: GeoPoint(6.3703, 2.3912),
              ));
        },
        child: CustomScrollView(
          slivers: [
            // 🎯 Header contextuel (Bonjour / Bonsoir)
            const SliverToBoxAdapter(
              child: ContextualHeader(),
            ),

            // ⚡ Événements spontanés (aujourd'hui)
            BlocBuilder<EventsFeedBloc, EventsFeedState>(
              builder: (context, state) {
                if (state.spontaneousEvents.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverToBoxAdapter(
                  child: _buildHorizontalSection(
                    title: '⚡ Aujourd\'hui près de vous',
                    events: state.spontaneousEvents,
                    cardBuilder: (event) => SpontaneousEventCard(event: event),
                  ),
                );
              },
            ),

            // 💎 Coups de cœur culturels
            BlocBuilder<EventsFeedBloc, EventsFeedState>(
              builder: (context, state) {
                if (state.culturalGems.isEmpty) {
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                }

                return SliverToBoxAdapter(
                  child: _buildHorizontalSection(
                    title: '💎 Expériences authentiques',
                    events: state.culturalGems,
                    cardBuilder: (event) => CulturalGemCard(event: event),
                  ),
                );
              },
            ),

            // 📅 Titre feed principal
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Text(
                  'Pour vous cette semaine',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // 📋 Feed principal personnalisé
            BlocBuilder<EventsFeedBloc, EventsFeedState>(
              builder: (context, state) {
                if (state.status == EventsFeedStatus.loading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.status == EventsFeedStatus.failure) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.w,
                            color: AppColors.error,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.errorMessage ?? 'Erreur de chargement',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.personalizedEvents.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64.w,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Aucun événement pour le moment',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final event = state.personalizedEvents[index];
                      return EventListTile(event: event);
                    },
                    childCount: state.personalizedEvents.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Widget pour sections horizontales (scroll)
  Widget _buildHorizontalSection({
    required String title,
    required List events,
    required Widget Function(dynamic event) cardBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: cardBuilder(events[index]),
              );
            },
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
