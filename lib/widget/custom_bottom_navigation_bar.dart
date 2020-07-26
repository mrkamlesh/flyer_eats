import 'package:clients/classes/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<BottomNavyBarItem> items;
  final Duration animationDuration;
  final double normalIconSize;
  final Color selectedColor;
  final Color unselectedColor;
  final ValueChanged<int> onItemSelected;
  final int selectedIndex;

  const CustomBottomNavBar({
    Key key,
    @required this.items,
    this.animationDuration = const Duration(milliseconds: 300),
    this.normalIconSize = kBottomNavigationBarHeight - 30,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.white70,
    @required this.onItemSelected,
    this.selectedIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> listItemWidget = items.map((item) {
      var index = items.indexOf(item);
      return Expanded(
        flex: 1,
        child: Container(
          child: FlatButton(
            onPressed: () {
              onItemSelected(index);
            },
            child: AnimatedBottomNavBarItem(
              icon: item.icon,
              title: item.title,
              badge: item.badge,
              animationDuration: animationDuration,
              normalHeight: normalIconSize,
              isSelected: (index == selectedIndex) ? true : false,
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ),
        ),
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.8, color: Colors.orange[200]))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: listItemWidget,
      ),
    );
  }
}

class AnimatedBottomNavBarItem extends StatelessWidget {
  final String icon;
  final String title;
  final bool isSelected;
  final Duration animationDuration;
  final double normalHeight;
  final Color selectedColor;
  final Color unselectedColor;
  final int badge;

  const AnimatedBottomNavBarItem(
      {Key key,
      this.icon,
      this.badge,
      this.title,
      this.isSelected,
      this.animationDuration,
      this.normalHeight,
      this.selectedColor,
      this.unselectedColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                curve: Curves.easeInCubic,
                height: isSelected ? normalHeight : normalHeight - 5,
                width: isSelected ? normalHeight : normalHeight - 5,
                duration: animationDuration,
                child: SvgPicture.asset(icon, color: isSelected ? selectedColor : unselectedColor),
              ),
              AnimatedOpacity(
                curve: Curves.easeInCubic,
                opacity: isSelected ? 1.0 : 0.0,
                duration: animationDuration,
                child: AnimatedDefaultTextStyle(
                    curve: Curves.easeInCubic,
                    child: Text(title),
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      color: isSelected ? selectedColor : unselectedColor,
                      fontSize: isSelected ? 11 : 0,
                    )),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    duration: animationDuration),
              )
            ],
          ),
          badge > 0
              ? Positioned(
                  top: 8,
                  left: normalHeight / 2,
                  child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary3,
                      ),
                      child: Center(
                        child: Text(
                          "$badge",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class BottomNavyBarItem {
  final String icon;
  final String title;
  final TextAlign textAlign;
  final int badge;

  BottomNavyBarItem({
    this.badge = 0,
    @required this.icon,
    @required this.title,
    this.textAlign,
  }) {
    assert(icon != null);
    assert(title != null);
  }
}
