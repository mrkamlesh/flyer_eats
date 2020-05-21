import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';

class PickShopLocationPage extends StatefulWidget {
  @override
  _PickShopLocationPageState createState() => _PickShopLocationPageState();
}

class _PickShopLocationPageState extends State<PickShopLocationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              height: (AppUtil.getScreenHeight(context) -
                      AppUtil.getToolbarHeight(context)) /
                  2,
              width: AppUtil.getScreenWidth(context),
              color: Colors.black12,
            ),
          ),
          Positioned(
            top: AppUtil.getToolbarHeight(context) / 2,
            left: 0,
            child: Container(
              padding: EdgeInsets.all(5),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black45),
                height: 30,
                width: 30,
                child: SvgPicture.asset(
                  "assets/back.svg",
                  color: Colors.white,
                )),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: AppUtil.getScreenWidth(context),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 0)
              ]),
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPaddingDraggable,
                  vertical: distanceBetweenSection),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CustomTextField(),
                  CustomTextField(),
                  CustomTextField(
                    lines: 3,
                  ),
                  Container(
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Done",
                      style: TextStyle(fontSize: 24),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int lines;

  const CustomTextField({Key key, this.hint, this.controller, this.lines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          hintText: hint != null ? hint : "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
