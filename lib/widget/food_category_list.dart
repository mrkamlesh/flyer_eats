import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/food_category.dart';
import 'package:flyereats/page/restaurants_list_page.dart';
import 'package:shimmer/shimmer.dart';

class FoodCategoryListWidget extends StatefulWidget {
  final List<FoodCategory> foodCategoryList;
  final double scale;

  const FoodCategoryListWidget({
    Key key,
    this.foodCategoryList,
    this.scale = 0.9,
  }) : super(key: key);

  @override
  _FoodCategoryListWidgetState createState() => _FoodCategoryListWidgetState();
}

class _FoodCategoryListWidgetState extends State<FoodCategoryListWidget>
    with SingleTickerProviderStateMixin {
  int _selectedFoodCategory = -1;
  AnimationController _animationController;
  Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: itemClickedDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scale).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));

  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.foodCategoryList.length + 1,
        itemBuilder: (context, i) {
          return i == 0
              ? SizedBox(
                  width: horizontalPaddingDraggable,
                )
              : FoodCategoryWidget(
                  foodCategory: widget.foodCategoryList[i - 1],
                  onTap: () {
                    setState(() {
                      _selectedFoodCategory = i - 1;
                      _animationController.forward().orCancel.whenComplete(() {
                        _animationController
                            .reverse()
                            .orCancel
                            .whenComplete(() {
                          _navigateToRestaurantList(
                              widget.foodCategoryList[i - 1]);
                        });
                      });
                    });
                  },
                  selectedIndex: _selectedFoodCategory,
                  index: i - 1,
                  scale: _scaleAnimation,
                );
        });
  }

  void _navigateToRestaurantList(FoodCategory foodCategory) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RestaurantListPage(
        title: foodCategory.name,
        image: foodCategory.image,
        isExternalImage: true,
      );
    }));
  }
}

class FoodCategoryWidget extends StatelessWidget {
  final FoodCategory foodCategory;
  final int index;
  final int selectedIndex;
  final Animation<double> scale;
  final Function onTap;

  const FoodCategoryWidget(
      {Key key,
      this.foodCategory,
      this.index,
      this.selectedIndex,
      this.scale,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget categoryWidget = GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 80,
        margin: EdgeInsets.only(right: distanceBetweenItem),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: foodCategory.image,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                      child: Container(
                        height: 80,
                        width: 80,
                        color: Colors.black,
                      ),
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100]);
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              foodCategory.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
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
            child: categoryWidget,
          )
        : categoryWidget;
  }
}
