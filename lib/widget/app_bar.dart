import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/classes/app_util.dart';

class CustomAppBar extends StatelessWidget {
  final String leading;
  final String title;

  final String drawer;
  final Function onTapLeading;
  final Function onTapTitle;
  final Function onTapDrawer;
  final Color backgroundColor;
  final bool isLoading;
  final bool isFlag;
  final bool isDropDownButtonVisible;

  const CustomAppBar(
      {Key key,
      this.leading,
      this.title,
      this.drawer,
      this.onTapLeading,
      this.onTapTitle,
      this.onTapDrawer,
      this.backgroundColor = Colors.black38,
      this.isLoading = false,
      this.isFlag = false,
      this.isDropDownButtonVisible = false})
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
              ? isFlag
                  ? GestureDetector(
                      onTap: onTapLeading,
                      child: Container(
                        height: kToolbarHeight,
                        width: 28,
                        margin: EdgeInsets.only(left: 12),
                        child: SvgPicture.asset(
                          leading,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    )
                  : GestureDetector(
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
            child: InkWell(
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
          isDropDownButtonVisible
              ? GestureDetector(
                  onTap: onTapTitle,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    height: kBottomNavigationBarHeight,
                    width: 20,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/dropdown home.svg",
                        height: 8,
                        width: 8,
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          isLoading
              ? SpinKitCircle(
                  color: Colors.white,
                  size: kToolbarHeight - 30,
                )
              : Container(),
          drawer != null
              ? GestureDetector(
                  onTap: onTapDrawer,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Center(
                      child: SvgPicture.asset(
                        drawer,
                        width: 18,
                        height: 18,
                      ),
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
