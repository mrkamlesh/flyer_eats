import 'package:clients/bloc/location/home/bloc.dart';
import 'package:clients/page/login/login_number_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/account_page.dart';
import 'package:clients/page/help_page.dart';
import 'package:clients/page/wallet_page.dart';
import 'package:clients/page/notifications_list_page.dart';
import 'package:clients/page/order_history_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

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
            child: BlocBuilder<LoginBloc, LoginState>(
              builder: (context, loginState) {
                return Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: loginState.user.avatar != null &&
                              loginState.user.avatar != ""
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: loginState.user.avatar,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        color: Colors.black,
                                      ),
                                      baseColor: Colors.grey[300],
                                      highlightColor: Colors.grey[100]);
                                },
                              ),
                            )
                          : FittedBox(
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
                            loginState.user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            loginState.user.phone,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                );
              },
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
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OrderHistoryPage();
              }));
            },
            child: Row(
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
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyWalletPage();
              }));
            },
            child: Row(
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
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NotificationSListPage();
              }));
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Notifications",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AppSettingsPage();
              }));*/
            },
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, homeState) {
                return InkWell(
                  onTap: homeState.homePageData != null
                      ? () {
                          if (homeState.homePageData.isReferralAvailable) {
                            AppUtil.share(
                                context,
                                homeState.homePageData.referralCode,
                                homeState.homePageData.currencyCode +
                                    " " +
                                    homeState.homePageData.referralDiscount);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Referral is not available in this location",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.black38,
                                timeInSecForIosWeb: 1,
                                fontSize: 16.0);
                          }
                        }
                      : () {},
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Refer A Friend",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                );
              },
            ),
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
          GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              await AppUtil.launchInBrowser(
                  "https://5v6vw.app.link/MaPgS0fNP8");
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Book A Ride",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HelpPage();
              }));
            },
            child: Row(
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
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          Expanded(child: SizedBox()),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
          SizedBox(
            height: distanceSectionContent,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return LoginNumberPage(
                  isLoggedOut: true,
                );
              }));
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Log Out",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
