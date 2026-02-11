import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';

/// Benin Experience - Story Ring Component
/// Cercle story avec bordure dégradée (Instagram-like)
class BEStoryRing extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;
  final bool viewed;
  final bool isPremium;
  final bool hasNewStory;

  const BEStoryRing({
    super.key,
    required this.imageUrl,
    required this.label,
    this.onTap,
    this.viewed = false,
    this.isPremium = false,
    this.hasNewStory = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: BESpacing.storySize + BESpacing.md,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cercle avec bordure dégradée
            Stack(
              alignment: Alignment.center,
              children: [
                // Bordure dégradée (si non vue)
                if (hasNewStory && !viewed)
                  Container(
                    width: BESpacing.storySize,
                    height: BESpacing.storySize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isPremium
                          ? BEColors.storyPremiumGradient
                          : BEColors.storyGradient,
                    ),
                  ),
                
                // Bordure grise (si vue)
                if (!hasNewStory || viewed)
                  Container(
                    width: BESpacing.storySize,
                    height: BESpacing.storySize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: BEColors.border,
                        width: BESpacing.storyBorder,
                      ),
                    ),
                  ),
                
                // Cercle blanc interne
                Container(
                  width: BESpacing.storyInner,
                  height: BESpacing.storyInner,
                  decoration: const BoxDecoration(
                    color: BEColors.background,
                    shape: BoxShape.circle,
                  ),
                ),
                
                // Image
                ClipOval(
                  child: SizedBox(
                    width: BESpacing.storyInner - 4,
                    height: BESpacing.storyInner - 4,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: BEColors.surface,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: BEColors.surface,
                        child: const Icon(
                          Icons.person,
                          color: BEColors.textTertiary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: BESpacing.xs),
            
            // Label
            SizedBox(
              width: BESpacing.storySize + BESpacing.sm,
              child: Text(
                label,
                style: BETypography.caption(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Benin Experience - Stories Feed Bar
/// Barre horizontale de stories (scrollable)
class BEStoriesFeedBar extends StatelessWidget {
  final List<StoryData> stories;

  const BEStoriesFeedBar({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110, // Story + label + padding
      color: BEColors.background,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: BESpacing.screenHorizontal,
          vertical: BESpacing.md,
        ),
        itemCount: stories.length,
        separatorBuilder: (context, index) => const SizedBox(
          width: BESpacing.md,
        ),
        itemBuilder: (context, index) {
          final story = stories[index];
          return BEStoryRing(
            imageUrl: story.imageUrl,
            label: story.label,
            onTap: story.onTap,
            viewed: story.viewed,
            isPremium: story.isPremium,
            hasNewStory: story.hasNewStory,
          );
        },
      ),
    );
  }
}

/// Model pour Story data
class StoryData {
  final String imageUrl;
  final String label;
  final VoidCallback? onTap;
  final bool viewed;
  final bool isPremium;
  final bool hasNewStory;

  StoryData({
    required this.imageUrl,
    required this.label,
    this.onTap,
    this.viewed = false,
    this.isPremium = false,
    this.hasNewStory = true,
  });
}
