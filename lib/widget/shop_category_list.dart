import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/shop_category.dart';
import 'package:flyereats/page/restaurants_list_page.dart';

class ShopCategoryListWidget extends StatefulWidget {
  final List<ShopCategory> shopCategories;

  const ShopCategoryListWidget({Key key, this.shopCategories})
      : super(key: key);

  @override
  _ShopCategoryListWidgetState createState() => _ShopCategoryListWidgetState();
}

class _ShopCategoryListWidgetState extends State<ShopCategoryListWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  int _selectedShop = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: itemClickedDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _listShopWidget = [];
    for (int i = 0; i < widget.shopCategories.length; i++) {
      _listShopWidget.add(Expanded(
        child: ShopCategoryWidget(
          widget.shopCategories[i],
          onTap: () {
            setState(() {
              _selectedShop = i;
              _animationController.forward().orCancel.whenComplete(() {
                _animationController.reverse().orCancel.whenComplete(() {
                  switch (i) {
                    case (0):
                      _navigateToRestaurantListPage();
                      break;
                    default:
                      break;
                  }
                });
              });
            });
          },
          scale: _scaleAnimation,
          index: i,
          selectedIndex: _selectedShop,
        ),
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _listShopWidget,
    );
  }

  void _navigateToRestaurantListPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RestaurantListPage();
    }));
  }
}

class ShopCategoryWidget extends StatelessWidget {
  final ShopCategory category;
  final Function onTap;
  final index;
  final selectedIndex;
  final Animation<double> scale;

  const ShopCategoryWidget(
    this.category, {
    Key key,
    this.onTap,
    this.index,
    this.selectedIndex,
    this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = (MediaQuery.of(context).size.width - 160) / 4;
    iconSize = iconSize >= 50 ? 50 : iconSize;

    //160 itu blank space yang fix dalm satu layar tanpa size dari icon
    //30 itu blank space yang fix dalam satu container selain size dari icon

    Widget child = GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: iconSize + 30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(
                top: 5,
                left: 5,
                right: 5,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(9, 10),
                        color: Colors.black26,
                        spreadRadius: -10,
                        blurRadius: 30)
                  ]),
              child: SizedBox(
                child: SvgPicture.asset(
                  category.icon,
                  width: iconSize,
                  height: iconSize,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13),
                ))
          ],
        ),
      ),
    );

    return selectedIndex == index
        ? AnimatedBuilder(
            animation: scale,
            builder: (context, child) {
              return Transform.scale(
                scale: scale.value,
                child: child,
              );
            },
            child: child,
          )
        : child;
  }
}
