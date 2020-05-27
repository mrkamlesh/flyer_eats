import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/app_util.dart';

class CustomAppBar extends StatelessWidget {
  final String leading;
  final String title;
  final String drawer;
  final Function onTapLeading;
  final Function onTapTitle;
  final Function onTapDrawer;
  final Color backgroundColor;

  const CustomAppBar(
      {Key key,
      this.leading,
      this.title,
      this.drawer,
      this.onTapLeading,
      this.onTapTitle,
      this.onTapDrawer,
      this.backgroundColor = Colors.black38})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: 16, right: 16, top: MediaQuery.of(context).padding.top),
      height: AppUtil.getToolbarHeight(context),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
          color: backgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          leading != null
              ? GestureDetector(
                  onTap: onTapLeading,
                  child: Container(
                    height: kToolbarHeight,
                    width: 40,
                    child: SvgPicture.asset(
                      leading,
                      color: Colors.white,
                      width: 20,
                      height: 20,
                      fit: BoxFit.none,
                    ),
                  ),
                )
              : SizedBox(
                  width: 28,
                ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTapTitle,
              child: Container(
                height: kToolbarHeight,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
          drawer != null
              ? GestureDetector(
                  onTap: onTapDrawer,
                  child: Container(
                    height: kToolbarHeight,
                    width: 40,
                    child: SvgPicture.asset(
                      drawer,
                      color: Colors.white,
                      width: 20,
                      height: 20,
                      fit: BoxFit.none,
                    ),
                  ),
                )
              : SizedBox(
                  width: 28,
                )
        ],
      ),
    );
  }
}
