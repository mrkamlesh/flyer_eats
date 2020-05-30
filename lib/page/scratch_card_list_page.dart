import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/example_model.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:shimmer/shimmer.dart';

class ScratchCardPage extends StatefulWidget {
  @override
  _ScratchCardPageState createState() => _ScratchCardPageState();
}

class _ScratchCardPageState extends State<ScratchCardPage> {
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
                  title: "Scratch Card",
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
                padding: EdgeInsets.only(
                    top: 20,
                    left: horizontalPaddingDraggable,
                    right: horizontalPaddingDraggable),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Total Scratch Card"),
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 11,
                                  height: 17,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: SvgPicture.asset(
                                      "assets/rupee.svg",
                                      color: primary3,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "123",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 36,
                                      color: primary3,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 1.7,
                            crossAxisCount: 2),
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
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: CachedNetworkImage(
          imageUrl: image,
          height: 60,
          width:
              AppUtil.getScreenWidth(context) - 3 * horizontalPaddingDraggable,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          placeholder: (context, url) {
            return Shimmer.fromColors(
                child: Container(
                  height: 60,
                  width: AppUtil.getScreenWidth(context) -
                      3 * horizontalPaddingDraggable,
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
