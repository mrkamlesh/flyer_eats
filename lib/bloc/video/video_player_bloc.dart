import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';

part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  @override
  VideoPlayerState get initialState => VideoPlayerInitial();

  @override
  Stream<VideoPlayerState> mapEventToState(
    VideoPlayerEvent event,
  ) async* {
    if (event is PlayVideo) {
      yield* mapPlayVideoToState(event.controller);
    }
  }

  Stream<VideoPlayerState> mapPlayVideoToState(
      VideoPlayerController controller) async* {
    await controller.initialize();
    controller.play();
    yield PlayingVideo();
  }
}
