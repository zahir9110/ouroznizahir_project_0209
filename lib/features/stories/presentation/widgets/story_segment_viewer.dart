import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../../domain/entities/story_segment.dart';

/// Widget pour afficher un segment (image ou vidéo)
class StorySegmentViewer extends StatefulWidget {
  final StorySegment segment;
  final bool isPlaying;

  const StorySegmentViewer({
    super.key,
    required this.segment,
    required this.isPlaying,
  });

  @override
  State<StorySegmentViewer> createState() => _StorySegmentViewerState();
}

class _StorySegmentViewerState extends State<StorySegmentViewer> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  @override
  void didUpdateWidget(StorySegmentViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.segment.id != widget.segment.id) {
      _disposeVideo();
      _initializeMedia();
    }

    if (widget.segment.type == StorySegmentType.video) {
      if (widget.isPlaying && !oldWidget.isPlaying) {
        _videoController?.play();
      } else if (!widget.isPlaying && oldWidget.isPlaying) {
        _videoController?.pause();
      }
    }
  }

  @override
  void dispose() {
    _disposeVideo();
    super.dispose();
  }

  void _initializeMedia() {
    if (widget.segment.type == StorySegmentType.video) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.segment.mediaUrl),
      )..initialize().then((_) {
          setState(() {});
          if (widget.isPlaying) {
            _videoController?.play();
          }
        });
    }
  }

  void _disposeVideo() {
    _videoController?.dispose();
    _videoController = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.segment.type == StorySegmentType.image) {
      return _buildImage();
    } else {
      return _buildVideo();
    }
  }

  Widget _buildImage() {
    return SizedBox.expand(
      child: CachedNetworkImage(
        imageUrl: widget.segment.mediaUrl,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.error, color: Colors.white, size: 48),
        ),
      ),
    );
  }

  Widget _buildVideo() {
    if (_videoController == null ||
        !_videoController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      ),
    );
  }
}
