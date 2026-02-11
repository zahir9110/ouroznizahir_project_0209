import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Barres de progression en haut de la story
class StoryProgressBar extends StatelessWidget {
  final int segmentCount;
  final int currentIndex;
  final bool isPlaying;
  final List<Duration> segmentDurations;

  const StoryProgressBar({
    super.key,
    required this.segmentCount,
    required this.currentIndex,
    required this.isPlaying,
    required this.segmentDurations,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: List.generate(segmentCount, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: _ProgressIndicator(
                isActive: index == currentIndex,
                isCompleted: index < currentIndex,
                isPlaying: isPlaying,
                duration: segmentDurations[index],
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Indicateur individuel avec animation
class _ProgressIndicator extends StatefulWidget {
  final bool isActive;
  final bool isCompleted;
  final bool isPlaying;
  final Duration duration;

  const _ProgressIndicator({
    required this.isActive,
    required this.isCompleted,
    required this.isPlaying,
    required this.duration,
  });

  @override
  State<_ProgressIndicator> createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<_ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.isActive && widget.isPlaying) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_ProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && widget.isPlaying && !oldWidget.isPlaying) {
      _controller.forward();
    } else if (!widget.isPlaying) {
      _controller.stop();
    }

    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.duration = widget.duration;
      if (widget.isPlaying) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double progress = 0.0;

          if (widget.isCompleted) {
            progress = 1.0;
          } else if (widget.isActive) {
            progress = _controller.value;
          }

          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        },
      ),
    );
  }
}
