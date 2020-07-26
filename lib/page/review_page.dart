import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/bloc/review/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/restaurant.dart';
import 'package:clients/model/review.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewPage extends StatefulWidget {
  final Restaurant restaurant;

  const ReviewPage({Key key, this.restaurant}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<ReviewBloc>(
          create: (context) {
            return ReviewBloc()
              ..add(GetReview(widget.restaurant.id, loginState.user.token));
          },
          child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: AppUtil.getScreenWidth(context),
                      height: AppUtil.getBannerHeight(context),
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: CachedNetworkImage(
                            imageUrl: widget.restaurant.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          )),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.black54),
                  width: AppUtil.getScreenWidth(context),
                  height: AppUtil.getBannerHeight(context),
                ),
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Builder(
                        builder: (context) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: MediaQuery.of(context).padding.top),
                            height: AppUtil.getToolbarHeight(context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: kToolbarHeight,
                                    width: 28,
                                    margin: EdgeInsets.only(left: 12),
                                    child: SvgPicture.asset(
                                      "assets/back.svg",
                                      color: Colors.white,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                    height: kToolbarHeight,
                                    alignment: Alignment.centerLeft,
                                    child: BlocBuilder<ReviewBloc, ReviewState>(
                                      builder: (context, state) {
                                        if (state is SuccessReviewState) {
                                          return Text(
                                            "Review (${state.listReview.length})",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          );
                                        }
                                        return SizedBox();
                                      },
                                    ),
                                  ),
                                ),
                                SmoothStarRating(
                                    allowHalfRating: true,
                                    onRated: (v) {},
                                    starCount: 5,
                                    rating:
                                        double.parse(widget.restaurant.rating.rating),
                                    size: 20.0,
                                    isReadOnly: true,
                                    color: primary3,
                                    borderColor: primary3,
                                    spacing: 0.0)
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                DraggableScrollableSheet(
                  initialChildSize: (AppUtil.getScreenHeight(context) -
                          AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  minChildSize: (AppUtil.getScreenHeight(context) -
                          AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  maxChildSize: 1.0,
                  builder: (context, controller) {
                    return Container(
                      padding: EdgeInsets.only(
                          top: 20,
                          left: horizontalPaddingDraggable,
                          right: horizontalPaddingDraggable),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(32),
                              topLeft: Radius.circular(32))),
                      child: BlocBuilder<ReviewBloc, ReviewState>(
                        builder: (context, state) {
                          if (state is SuccessReviewState) {
                            return CustomScrollView(
                              controller: controller,
                              shrinkWrap: false,
                              slivers: <Widget>[
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (context, i) {
                                  return ReviewWidget(
                                    review: state.listReview[i],
                                  );
                                }, childCount: state.listReview.length))
                              ],
                            );
                          } else if (state is LoadingReviewState) {
                            return Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SpinKitCircle(
                                      color: Colors.black38,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text("Loading Reviews..."),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is ErrorReviewState) {
                            return Container(
                              height: AppUtil.getDraggableHeight(context),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(32),
                                      topLeft: Radius.circular(32))),
                              padding: EdgeInsets.only(
                                  top: 20,
                                  left: horizontalPaddingDraggable,
                                  right: horizontalPaddingDraggable),
                              alignment: Alignment.center,
                              child: Container(
                                child: Center(
                                  child: Text("Error Get Review"),
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReviewWidget extends StatelessWidget {
  final Review review;

  const ReviewWidget({Key key, this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: review.avatar,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                        child: Container(
                          height: 70,
                          width: 70,
                          color: Colors.black,
                        ),
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100]);
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      review.username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      review.review,
                      style: TextStyle(
                          fontSize: 13,
                          /*color: Color(0xFF3C3C3C)*/
                          color: Colors.black38),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          review.date,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SmoothStarRating(
                        allowHalfRating: true,
                        onRated: (v) {},
                        starCount: 5,
                        rating: review.rating,
                        size: 20.0,
                        isReadOnly: true,
                        color: primary3,
                        borderColor: primary3,
                        spacing: 0.0),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              )
            ],
          ),
          Divider(
            color: Colors.black38,
          ),
        ],
      ),
    );
  }
}
