part of 'video_player_bloc.dart';

@immutable
abstract class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();
}

class PlayVideo extends VideoPlayerEvent {
  final VideoPlayerController controller;

  PlayVideo(this.controller);

  @override
  List<Object> get props => [controller];
}
