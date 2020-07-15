import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/example_model.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:shimmer/shimmer.dart';

class LoyaltyRewardPointsPage extends StatefulWidget {
  @override
  _LoyaltyRewardPointsPageState createState() =>
      _LoyaltyRewardPointsPageState();
}

class _LoyaltyRewardPointsPageState extends State<LoyaltyRewardPointsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Image.asset(
                      "assets/allrestaurant.png",
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
                child: CustomAppBar(
                  leading: "assets/back.svg",
                  title: "Loyalty Reward Points",
                  onTapLeading: () {
                    Navigator.pop(context);
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
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32),
                        topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(top: 20),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, i) {
                      List<String> list = ExampleModel.getLoyatyRewards();
                      return LoyaltyRewardItem(image: list[i]);
                    }, childCount: ExampleModel.getLoyatyRewards().length))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LoyaltyRewardItem extends StatelessWidget {
  final String image;

  const LoyaltyRewardItem({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: horizontalPaddingDraggable,
          right: horizontalPaddingDraggable,
          bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: CachedNetworkImage(
          imageUrl: image,
          height: 60,
          width: AppUtil.getScreenWidth(context),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          placeholder: (context, url) {
            return Shimmer.fromColors(
                child: Container(
                  height: 60,
                  width: AppUtil.getScreenWidth(context),
                  color: Colors.black,
                ),
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100]);
          },
        ),
      ),
    );
  }
}
