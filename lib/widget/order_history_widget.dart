import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/order.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryWidget extends StatefulWidget {
  final Order order;

  const OrderHistoryWidget({Key key, this.order}) : super(key: key);

  @override
  _OrderHistoryWidgetState createState() => _OrderHistoryWidgetState();
}

class _OrderHistoryWidgetState extends State<OrderHistoryWidget> {
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
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: widget.order.restaurant.image,
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
                        widget.order.restaurant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.order.restaurant.location,
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
              "Dosa x 1, Idly x 1",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              widget.order.date,
              style: TextStyle(fontSize: 13, color: Colors.black38),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 7,
                  height: 7,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SvgPicture.asset(
                      "assets/rupee.svg",
                      color: Colors.black38,
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  "230",
                  style: TextStyle(fontSize: 13, color: Colors.black38),
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
                          child: SvgPicture.asset("assets/check.svg"))),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Delivered",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 15),
                child: Text(
                  "REORDER",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary3),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
