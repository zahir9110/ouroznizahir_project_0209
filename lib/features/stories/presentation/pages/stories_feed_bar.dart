import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/story.dart';
import '../bloc/stories_feed_bloc.dart';
import '../bloc/stories_feed_event.dart';
import '../bloc/stories_feed_state.dart';
import '../widgets/story_ring.dart';
import 'story_viewer_page.dart';

/// Barre horizontale de stories (comme Instagram)
class StoriesFeedBar extends StatelessWidget {
  final String currentUserId;

  const StoriesFeedBar({
    super.key,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StoriesFeedBloc>()
        ..add(LoadStoriesFeed(currentUserId)),
      child: SizedBox(
        height: 100.h,
        child: BlocBuilder<StoriesFeedBloc, StoriesFeedState>(
          builder: (context, state) {
            if (state.status == StoriesFeedStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == StoriesFeedStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Erreur chargement stories',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12.sp,
                  ),
                ),
              );
            }

            if (state.groupedStories.isEmpty) {
              return Center(
                child: Text(
                  'Aucune story disponible',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: state.groupedStories.length + 1,
              itemBuilder: (context, index) {
                // Premier item = "Votre story"
                if (index == 0) {
                  return _buildAddStoryButton(context);
                }

                final userId = state.groupedStories.keys.elementAt(index - 1);
                final userStories = state.groupedStories[userId]!;
                final firstStory = userStories.first;

                return StoryRing(
                  userId: userId,
                  displayName: firstStory.userDisplayName,
                  photoUrl: firstStory.userPhotoUrl,
                  hasNewContent: true, // TODO: logique vue/non vue
                  onTap: () {
                    _openStoryViewer(
                      context,
                      userStories,
                      currentUserId,
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// Bouton "Ajouter story"
  Widget _buildAddStoryButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // TODO: Ouvrir créateur de story
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Créateur de story à implémenter'),
                ),
              );
            },
            child: Container(
              width: 68.w,
              height: 68.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surface,
                border: Border.all(
                  color: AppColors.divider,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add,
                size: 32.w,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Votre story',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Ouvrir le viewer plein écran
  void _openStoryViewer(
    BuildContext context,
    List<Story> stories,
    String viewerId,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryViewerPage(
          stories: stories,
          viewerId: viewerId,
        ),
      ),
    );
  }
}
