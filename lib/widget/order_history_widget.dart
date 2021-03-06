import 'package:cached_network_image/cached_network_image.dart';
import 'package:clients/classes/app_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/order.dart';
import 'package:shimmer/shimmer.dart';

class FoodOrderHistoryWidget extends StatelessWidget {
  final Order order;

  const FoodOrderHistoryWidget({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: horizontalPaddingDraggable,
          right: horizontalPaddingDraggable,
          bottom: horizontalPaddingDraggable),
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 7,
            spreadRadius: -3,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: order.restaurant.image,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.black,
                            ),
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100]);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        order.restaurant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        order.restaurant.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.black26),
                      ),
                    ],
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
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              order.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            child: Text(
              order.itemsString,
              style:
                  TextStyle(fontSize: 15, color: Colors.black45, height: 1.3),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              order.date,
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              AppUtil.getCurrencyString(order.currencyCode) + " " + order.total,
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Divider(
              height: 0.5,
              color: Colors.black12,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                      width: 18,
                      height: 18,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset(order.getIcon()))),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    order.status,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              /*Container(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: Text(
                  "REORDER",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary3),
                ),
              )*/
            ],
          )
        ],
      ),
    );
  }
}

class PickupOrderHistoryWidget extends StatelessWidget {
  final PickupOrder pickupOrder;

  const PickupOrderHistoryWidget({Key key, this.pickupOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: horizontalPaddingDraggable,
          right: horizontalPaddingDraggable,
          bottom: horizontalPaddingDraggable),
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: shadow,
            blurRadius: 7,
            spreadRadius: -3,
          )
        ],
      ),
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
                  pickupOrder.shopName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  pickupOrder.pickupAddress ?? "",
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
            child: Text(
              pickupOrder.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            child: Text(
              pickupOrder.getItemString(),
              style:
                  TextStyle(fontSize: 16, color: Colors.black45, height: 1.3),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              pickupOrder.date,
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              AppUtil.getCurrencyString(pickupOrder.currencyCode) +
                  " " +
                  pickupOrder.amount,
              style: TextStyle(fontSize: 13, color: Colors.black38),
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
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: <Widget>[
                SizedBox(
                    width: 18,
                    height: 18,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: SvgPicture.asset(pickupOrder.getIcon()))),
                SizedBox(
                  width: 10,
                ),
                Text(
                  pickupOrder.status,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
