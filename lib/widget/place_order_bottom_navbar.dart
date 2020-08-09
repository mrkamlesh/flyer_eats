import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:clients/classes/app_util.dart';

class OrderBottomNavBar extends StatelessWidget {
  final amount;
  final String description;
  final String buttonText;
  final bool showCurrency;
  final Function onButtonTap;
  final bool isValid;
  final String currencyIcon;

  const OrderBottomNavBar(
      {Key key,
      this.amount,
      this.description,
      this.buttonText,
      this.showCurrency,
      this.onButtonTap,
      this.isValid,
      this.currencyIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      width: AppUtil.getScreenWidth(context),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.yellow[600]))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  description,
                  style: TextStyle(fontSize: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    showCurrency
                        ? Container(
                            margin: EdgeInsets.only(right: 10),
                            child: SvgPicture.asset(
                              currencyIcon,
                              width: 13,
                              height: 13,
                            ),
                          )
                        : Container(),
                    Text(
                      "$amount",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child: GestureDetector(
            onTap: isValid ? onButtonTap : () {},
            child: SizedBox.expand(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.yellow[600], borderRadius: BorderRadius.only(topLeft: Radius.circular(18))),
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isValid ? 0.0 : 0.65,
                    child: Container(
                      color: Colors.white,
                    ),
                    duration: Duration(milliseconds: 300),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
