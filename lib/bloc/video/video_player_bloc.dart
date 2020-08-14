import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  Stream<VideoPlayerState> mapPlayVideoToState(YoutubePlayerController controller) async* {
    //await controller.initialize();
    //controller.play();
    controller.play();
    yield PlayingVideo();
  }
}
