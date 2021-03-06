import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/bloc/video/video_player_bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/ads.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AdsListWidget extends StatefulWidget {
  final List<Ads> adsList;

  const AdsListWidget({Key key, this.adsList}) : super(key: key);

  @override
  _AdsListWidgetState createState() => _AdsListWidgetState();
}

class _AdsListWidgetState extends State<AdsListWidget> {
  PageController _pageController;
  double _adsOffset;
  Timer _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: 0, viewportFraction: viewport);

    _timer = Timer.periodic(Duration(seconds: 6), (t) {
      _currentIndex++;
      _pageController.animateToPage(_currentIndex % widget.adsList.length,
          duration: Duration(milliseconds: 700), curve: Curves.ease);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _adsOffset = -((1 - viewport) * MediaQuery.of(context).size.width / 2 -
        horizontalPaddingDraggable);
    return PageView.builder(
        controller: _pageController,
        onPageChanged: (i) {
          _currentIndex = i % widget.adsList.length;
        },
        pageSnapping: true,
        itemCount: widget.adsList.length,
        itemBuilder: (context, i) {
          return Transform.translate(
            offset: Offset(_adsOffset, 0),
            child: AdsWidget(
              ads: widget.adsList[i],
            ),
          );
        });
  }
}

class AdsWidget extends StatefulWidget {
  final Ads ads;

  const AdsWidget({Key key, this.ads}) : super(key: key);

  @override
  _AdsWidgetState createState() => _AdsWidgetState();
}

class _AdsWidgetState extends State<AdsWidget> {
  //VideoPlayerController _videoController;
  YoutubePlayerController _youtubePlayerController;
  VideoPlayerBloc _videoPlayerBloc = VideoPlayerBloc();
  String videoId;

  @override
  void dispose() {
    _videoPlayerBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.ads.type == "video") {
      videoId = YoutubePlayer.convertUrlToId(widget.ads.videoUrl);
      if (videoId != null) {
        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: videoId,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.ads.type == "video") {
          _videoPlayerBloc.add(PlayVideo(_youtubePlayerController));
          await showMaterialModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              context: context,
              duration: Duration(milliseconds: 200),
              builder: (context, controller) {
                if (videoId == null) {
                  return Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Can not play youtube video, URL is invalid",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                  bloc: _videoPlayerBloc,
                  builder: (context, state) {
                    if (state is VideoPlayerInitial) {
                      return Container(
                          height: 150,
                          margin: EdgeInsets.all(horizontalPaddingDraggable),
                          child: Center(
                              child: SpinKitCircle(
                            color: Colors.black38,
                            size: 30,
                          )));
                    } else {
                      return Container(
                        margin: EdgeInsets.all(horizontalPaddingDraggable),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            YoutubePlayer(
                              controller: _youtubePlayerController,
                            ),
                            InkWell(
                              onTap: () {
                                AppUtil.launchInBrowser(widget.ads.url);
                              },
                              child: Text(
                                "CLICK HERE",
                                style: TextStyle(
                                    color: primary3,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  },
                );
              });

          if (widget.ads.type == "video") if (_youtubePlayerController
              .value.isPlaying) {
            _youtubePlayerController.pause();
          }
        } else {
          showMaterialModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              context: context,
              duration: Duration(milliseconds: 200),
              builder: (context, controller) {
                return InkWell(
                  onTap: () {
                    AppUtil.launchInBrowser(widget.ads.url);
                  },
                  child: Container(
                    margin: EdgeInsets.all(horizontalPaddingDraggable),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: CachedNetworkImage(
                        imageUrl: widget.ads.photo,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                              child: Container(
                                height: 150,
                                color: Colors.black,
                              ),
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100]);
                        },
                      ),
                    ),
                  ),
                );
              });
        }
      },
      child: BlocProvider<VideoPlayerBloc>(
        create: (context) {
          return _videoPlayerBloc;
        },
        child: Container(
          margin: EdgeInsets.only(right: 20, top: 5, bottom: 5),
          height: 60,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(2, 2),
                  color: Colors.black26,
                  spreadRadius: 0,
                  blurRadius: 5)
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: widget.ads.type == "video"
                  ? widget.ads.thumbnail
                  : widget.ads.photo,
              height: 60,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              placeholder: (context, url) {
                return Shimmer.fromColors(
                    child: Container(
                      color: Colors.black,
                    ),
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[100]);
              },
            ),
          ),
        ),
      ),
    );
  }
}

/*class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}*/
