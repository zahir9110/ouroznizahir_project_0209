import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/story.dart';
import '../bloc/story_viewer_bloc.dart';
import '../bloc/story_viewer_event.dart';
import '../bloc/story_viewer_state.dart';
import '../widgets/story_progress_bar.dart';
import '../widgets/story_cta_button.dart';
import '../widgets/story_segment_viewer.dart';

/// Page plein écran pour voir une story (style Instagram)
class StoryViewerPage extends StatelessWidget {
  final List<Story> stories;
  final String viewerId;

  const StoryViewerPage({
    super.key,
    required this.stories,
    required this.viewerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StoryViewerBloc>()
        ..add(InitializeStoryViewer(
          story: stories.first,
          viewerId: viewerId,
        )),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocConsumer<StoryViewerBloc, StoryViewerState>(
          listener: (context, state) {
            if (state.isCompleted) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state.story == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return GestureDetector(
              onTapDown: (details) => _handleTap(context, details, state),
              onLongPressStart: (_) {
                context.read<StoryViewerBloc>().add(const PauseSegment());
              },
              onLongPressEnd: (_) {
                context.read<StoryViewerBloc>().add(const PlaySegment());
              },
              child: Stack(
                children: [
                  // Segment actuel (image/vidéo)
                  StorySegmentViewer(
                    segment: state.story!.segments[state.currentSegmentIndex],
                    isPlaying: state.isPlaying,
                  ),

                  // Gradient overlay top/bottom
                  _buildGradients(),

                  // Header (progress bars + info user)
                  _buildHeader(context, state),

                  // CTA button (si présent)
                  if (state.story!.cta != null)
                    Positioned(
                      bottom: 100.h,
                      left: 0,
                      right: 0,
                      child: StoryCTAButton(
                        cta: state.story!.cta!,
                        onTap: () => _handleCTATap(context, state),
                      ),
                    ),

                  // Close button
                  Positioned(
                    top: 50.h,
                    right: 16.w,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Header avec barres progression + info user
  Widget _buildHeader(BuildContext context, StoryViewerState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          children: [
            // Barres de progression
            StoryProgressBar(
              segmentCount: state.story!.segments.length,
              currentIndex: state.currentSegmentIndex,
              isPlaying: state.isPlaying,
              segmentDurations: state.story!.segments
                  .map((s) => s.duration)
                  .toList(),
            ),

            SizedBox(height: 12.h),

            // Info utilisateur
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: state.story!.userPhotoUrl.isNotEmpty
                        ? NetworkImage(state.story!.userPhotoUrl)
                        : null,
                    child: state.story!.userPhotoUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.story!.userDisplayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _formatTimeAgo(state.story!.createdAt),
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.story!.isVerified)
                    Icon(
                      Icons.verified,
                      color: AppColors.primaryGreen,
                      size: 20.sp,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gradients overlay
  Widget _buildGradients() {
    return Column(
      children: [
        Container(
          height: 150.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const Spacer(),
        Container(
          height: 200.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Gérer tap (gauche = précédent, droite = suivant)
  void _handleTap(
    BuildContext context,
    TapDownDetails details,
    StoryViewerState state,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;

    if (tapX < screenWidth / 3) {
      // Tap gauche = segment précédent
      context.read<StoryViewerBloc>().add(const PreviousSegment());
    } else if (tapX > screenWidth * 2 / 3) {
      // Tap droite = segment suivant
      context.read<StoryViewerBloc>().add(const NextSegment());
    }
  }

  /// Gérer clic CTA
  void _handleCTATap(BuildContext context, StoryViewerState state) {
    if (state.story?.cta == null) return;

    // TODO: Router vers action (achat billet, chat, événement)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CTA: ${state.story!.cta!.text}'),
      ),
    );
  }

  /// Formater temps relatif
  String _formatTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return '${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}j';
    }
  }
}
