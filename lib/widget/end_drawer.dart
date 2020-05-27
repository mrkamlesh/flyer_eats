import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/page/account_page.dart';

class EndDrawer extends StatelessWidget {
  final String image;
  final String name;
  final String number;

  const EndDrawer({Key key, this.image, this.name, this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppUtil.getScreenHeight(context),
      width: AppUtil.getScreenWidth(context) - 50,
      padding: EdgeInsets.only(
          left: horizontalPaddingDraggable,
          right: horizontalPaddingDraggable,
          top: MediaQuery.of(context).padding.top + horizontalPaddingDraggable,
          bottom: horizontalPaddingDraggable),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AccountPage();
              }));
            },
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  child: FittedBox(
                    fit: BoxFit.none,
                    child: SvgPicture.asset(
                      "assets/account.svg",
                      height: 20,
                      width: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Saravanan Nagarajan",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "9620077525",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Order History",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "My Wallet",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "App Settings",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Help",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }
}
