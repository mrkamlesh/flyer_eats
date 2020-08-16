import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/bloc/detailorder/pickup/bloc.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class PickupOrderDetailPage extends StatefulWidget {
  final String orderId;

  const PickupOrderDetailPage({Key key, this.orderId}) : super(key: key);

  @override
  _PickupOrderDetailPageState createState() => _PickupOrderDetailPageState();
}

class _PickupOrderDetailPageState extends State<PickupOrderDetailPage> {
  PickupDetailOrderBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PickupDetailOrderBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<PickupDetailOrderBloc>(
          create: (context) {
            return _bloc..add(GetDetailPickupOrder(loginState.user.token, widget.orderId));
          },
          child: BlocBuilder<PickupDetailOrderBloc, PickupDetailOrderState>(
            builder: (context, state) {
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
                            title: "Order Summary",
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
                              borderRadius:
                                  BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                          padding: EdgeInsets.only(
                              left: horizontalPaddingDraggable, right: horizontalPaddingDraggable, top: 30),
                          child: BlocBuilder<PickupDetailOrderBloc, PickupDetailOrderState>(
                            builder: (context, state) {
                              if (state is LoadingPickupDetailOrderState) {
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
                                        Text("Loading Order History..."),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (state is ErrorPickupDetailOrderState) {
                                return Container(
                                  height: AppUtil.getDraggableHeight(context),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                                  alignment: Alignment.center,
                                  child: Container(
                                    child: Center(
                                      child: Text(state.message),
                                    ),
                                  ),
                                );
                              }
                              return SingleChildScrollView(
                                controller: controller,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Shop Name: " + state.detailOrder.shopName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            state.detailOrder.shopAddress,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12, color: Colors.black26),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Divider(
                                        height: 0.5,
                                        color: Colors.black12,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              state.detailOrder.title,
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            state.detailOrder.date,
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: Divider(
                                        height: 0.5,
                                        color: Colors.black12,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "Order Detail",
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                    ),
                                    Text(state.detailOrder.items.join(", ")),
                                    state.detailOrder.thumbnails.length > 0
                                        ? Container(
                                            margin: EdgeInsets.only(bottom: 10, top: 10),
                                            child: Text(
                                              "Attachment",
                                              style: TextStyle(color: Colors.black45),
                                            ),
                                          )
                                        : SizedBox(),
                                    state.detailOrder.thumbnails.length > 0
                                        ? Container(
                                            width: AppUtil.getScreenWidth(context) - 80,
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              children: List.generate(state.detailOrder.thumbnails.length, (index) {
                                                return ImageThumbnail(state.detailOrder.thumbnails[index]);
                                              }),
                                            ),
                                          )
                                        : SizedBox(),
                                    Container(
                                      margin: EdgeInsets.only(top: 10, bottom: 10),
                                      child: Divider(
                                        height: 0.5,
                                        color: Colors.black12,
                                      ),
                                    ),
                                    Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 7,
                                                    child: Text(
                                                      "Total",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      state.detailOrder.total,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: 10),
                                              child: Divider(
                                                height: 0.5,
                                                color: Colors.black12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        state.detailOrder.getCurrentStatus().isDelivered()
                                            ? Positioned(
                                                bottom: -50,
                                                left: 50,
                                                child: Image.asset(
                                                  "assets/delivered signature.png",
                                                  width: 150,
                                                  height: 150,
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                    state.detailOrder.deliveryInstruction != null &&
                                            state.detailOrder.deliveryInstruction != ""
                                        ? Container(
                                            margin: EdgeInsets.only(top: 5, bottom: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "ORDER INSTRUCTION",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(state.detailOrder.deliveryInstruction),
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(32), topRight: Radius.circular(32))),
                                            backgroundColor: Colors.white,
                                            context: context,
                                            builder: (context) {
                                              List<Widget> statusWidgets = List();
                                              for (int i = 0; i < state.detailOrder.statusHistory.length; i++) {
                                                statusWidgets.add(
                                                  Container(
                                                    margin: EdgeInsets.symmetric(vertical: 3),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            SvgPicture.asset(
                                                              state.detailOrder.statusHistory[i].getIconAssets(),
                                                              width: 60,
                                                              height: 60,
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Text(
                                                                    state.detailOrder.statusHistory[i].status,
                                                                    style: TextStyle(
                                                                        fontSize: 20, fontWeight: FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Row(
                                                                        children: <Widget>[
                                                                          Icon(
                                                                            Icons.calendar_today,
                                                                            size: 16,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Text(state
                                                                              .detailOrder.statusHistory[i].dateCreated)
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      Row(
                                                                        children: <Widget>[
                                                                          Icon(
                                                                            Icons.access_time,
                                                                            color: primary3,
                                                                            size: 16,
                                                                          ),
                                                                          SizedBox(
                                                                            width: 5,
                                                                          ),
                                                                          Text(
                                                                            state.detailOrder.statusHistory[i].time,
                                                                            style: TextStyle(color: primary3),
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        i != state.detailOrder.statusHistory.length - 1
                                                            ? Container(
                                                                margin: EdgeInsets.only(left: 25),
                                                                child: SvgPicture.asset(
                                                                  "assets/separator icon.svg",
                                                                  height: 60,
                                                                  width: 15,
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }

                                              return Wrap(
                                                children: <Widget>[
                                                  Stack(
                                                    children: <Widget>[
                                                      SingleChildScrollView(
                                                        child: Container(
                                                          padding: EdgeInsets.only(
                                                              left: 20,
                                                              right: 20,
                                                              bottom: kBottomNavigationBarHeight,
                                                              top: 20),
                                                          decoration:
                                                              BoxDecoration(borderRadius: BorderRadius.circular(32)),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Container(
                                                                margin: EdgeInsets.only(bottom: 52),
                                                              ),
                                                              Column(
                                                                children: statusWidgets,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        left: 0,
                                                        child: Container(
                                                            width: AppUtil.getScreenWidth(context),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(32),
                                                                    topRight: Radius.circular(32)),
                                                                color: Colors.white),
                                                            padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                                                            child: Row(
                                                              children: <Widget>[
                                                                Expanded(
                                                                    flex: 2,
                                                                    child: GestureDetector(
                                                                      onTap: () {
                                                                        Navigator.pop(context);
                                                                      },
                                                                      child: Icon(Icons.clear),
                                                                    )),
                                                                Expanded(
                                                                  flex: 8,
                                                                  child: Text(
                                                                    "Track Order Timeline",
                                                                    style: TextStyle(
                                                                        fontSize: 18, fontWeight: FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 50,
                                        margin: state.detailOrder.deliveryInstruction != null &&
                                                state.detailOrder.deliveryInstruction != ""
                                            ? EdgeInsets.only(top: 30, bottom: 30)
                                            : EdgeInsets.only(top: 50, bottom: 30),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFB531),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          state.detailOrder.statusHistory.last.isDelivered()
                                              ? "TRACK ORDER TIMELINE"
                                              : "TRACK ORDER",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class ImageThumbnail extends StatelessWidget {
  final String image;

  ImageThumbnail(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.only(right: 15, bottom: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: image,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          placeholder: (context, url) {
            return Shimmer.fromColors(
                child: Container(
                  height: 60,
                  width: 60,
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
