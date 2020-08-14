import 'package:flutter/material.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/widget/app_bar.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
                  title: "Help",
                  onTapLeading: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                AppUtil.getScreenHeight(context),
            minChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                AppUtil.getScreenHeight(context),
            maxChildSize: 1.0,
            builder: (context, controller) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                padding: EdgeInsets.only(top: 20, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                child: Column(
                  children: <Widget>[
                    HelpItem(
                      title: "T & C",
                      onTap: () async {
                        await AppUtil.launchInBrowser("https://flyereats.in/page-terms-amp-conditions");
                      },
                    ),
                    HelpItem(
                      title: "P & P",
                      onTap: () async {
                        await AppUtil.launchInBrowser("https://flyereats.in/page-privacy-policy");
                      },
                    ),
                    HelpItem(
                      title: "FAQs",
                      onTap: () async {
                        await AppUtil.launchInBrowser("https://flyereats.in/page-faq");
                      },
                    ),
                    HelpItem(
                      title: "Contact US",
                      onTap: () async {
                        await AppUtil.launchInBrowser("https://flyereats.in/contact");
                      },
                    ),
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

class HelpItem extends StatelessWidget {
  final String title;
  final Function onTap;

  const HelpItem({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
        margin: EdgeInsets.only(bottom: horizontalPaddingDraggable),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
            Divider(
              height: 0.5,
              color: Colors.black38,
            )
          ],
        ),
      ),
    );
  }
}
