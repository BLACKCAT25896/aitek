import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yt_mobile;
import 'package:youtube_player_iframe/youtube_player_iframe.dart' as yt_web;
import 'iframe_view_registrar.dart';

class UniversalVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final void Function()? onTap;

  const UniversalVideoPlayer({super.key, required this.videoUrl, this.onTap});

  @override
  State<UniversalVideoPlayer> createState() => _UniversalVideoPlayerState();
}

class _UniversalVideoPlayerState extends State<UniversalVideoPlayer> {
  VideoPlayerController? _videoController;
  Future<void>? _initializeVideoFuture;
  String? _youtubeThumbnailUrl;

  @override
  void initState() {
    super.initState();
    _setupPreview();
  }

  void _setupPreview() {
    final youtubeId = _extractYoutubeId(widget.videoUrl);
    if (youtubeId != null) {
      _youtubeThumbnailUrl = 'https://img.youtube.com/vi/$youtubeId/0.jpg';
    } else if (!kIsWeb && !_isWebEmbed(widget.videoUrl)) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      _initializeVideoFuture = _videoController!.initialize();
    }
  }

  bool _isGoogleDriveUrl(String url) => url.contains('drive.google.com') && url.contains('/file/d/');
  bool _isVimeoEmbedUrl(String url) => url.contains('player.vimeo.com/video/');
  bool _isWebEmbed(String url) => kIsWeb && (_isGoogleDriveUrl(url) || _isVimeoEmbedUrl(url));

  String? _extractYoutubeId(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
      } else if (uri.host.contains('youtube.com')) {
        return uri.queryParameters['v'];
      }
    } catch (_) {}
    return null;
  }

  String _getEmbedUrl(String url) {
    if (_isGoogleDriveUrl(url)) {
      final fileId = Uri.parse(url).pathSegments[2];
      return 'https://drive.google.com/file/d/$fileId/preview';
    } else if (_isVimeoEmbedUrl(url)) {
      return url;
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () => _showDialog(context),
      child: Stack(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.black12,
            child: _buildPreview(),
          ),
          const Positioned.fill(
            child: Center(
              child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    if (_youtubeThumbnailUrl != null) {
      return Image.network(
        _youtubeThumbnailUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
      );
    } else if (_videoController != null && _initializeVideoFuture != null) {
      return FutureBuilder(
        future: _initializeVideoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return VideoPlayer(_videoController!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }
    return const SizedBox();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.black,
        child: SizedBox(width: 600,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: _buildFullPlayer(),
          ),
        ),
      ),
    );
  }

  Widget _buildFullPlayer() {
    final youtubeId = _extractYoutubeId(widget.videoUrl);

    if (kIsWeb && youtubeId != null) {
      final controller = yt_web.YoutubePlayerController.fromVideoId(
        videoId: youtubeId,
        params: const yt_web.YoutubePlayerParams(
          mute: false,
          showControls: true,
          showFullscreenButton: true,
          playsInline: true,
          enableCaption: false,
        ),
      );
      return yt_web.YoutubePlayerControllerProvider(
        controller: controller,
        child: yt_web.YoutubePlayer(controller: controller),
      );
    } else if (!kIsWeb && youtubeId != null) {
      final controller = yt_mobile.YoutubePlayerController(
        initialVideoId: youtubeId,
        flags: const yt_mobile.YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
      return yt_mobile.YoutubePlayer(controller: controller);
    } else if (_isWebEmbed(widget.videoUrl)) {
      final embedUrl = _getEmbedUrl(widget.videoUrl);
      registerIframe(embedUrl, interactionEnabled: true);
      final viewId = 'iframe_${embedUrl.hashCode}';
      return HtmlElementView(viewType: viewId);
    } else {
      final controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      return FutureBuilder(
        future: controller.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final chewieController = ChewieController(
              videoPlayerController: controller,
              autoPlay: true,
              looping: false,
            );
            return Chewie(controller: chewieController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
