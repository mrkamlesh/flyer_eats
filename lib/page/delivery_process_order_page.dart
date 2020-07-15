import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clients/bloc/delivery/delivery_order_event.dart';
import 'package:clients/model/shop.dart';
import 'package:clients/model/pickup.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/delivery/delivery_order_bloc.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/delivery_pickup_location.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/end_drawer.dart';
import 'package:clients/widget/place_order_bottom_navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clients/page/delivery_place_order_page.dart';

class DeliveryProcessOrderPage extends StatefulWidget {
  @override
  _DeliveryProcessOrderPageState createState() =>
      _DeliveryProcessOrderPageState();
}

class _DeliveryProcessOrderPageState extends State<DeliveryProcessOrderPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;

  List<TextEditingController> _controllers = [];

  DeliveryOrderBloc _bloc = DeliveryOrderBloc();

  final _keySliverAnimatedList = GlobalKey<SliverAnimatedListState>();
  final _keyAnimatedList = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _navBarAnimation = Tween<Offset>(
            begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(
            CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeliveryOrderBloc>(
      create: (context) {
        return _bloc;
      },
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        endDrawer: EndDrawer(),
        bottomNavigationBar: AnimatedBuilder(
            animation: _navBarAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: _navBarAnimation.value,
                child: child,
              );
            },
            child: BlocBuilder<DeliveryOrderBloc, PickUp>(
                builder: (context, pickup) {
              int length = 0;
              for (int i = 0; i < pickup.items.length; i++) {
                if ((pickup.items[i] != null) & (pickup.items[i] != "")) {
                  length++;
                }
              }
              return OrderBottomNavBar(
                isValid: pickup.isValid(),
                amount: length,
                description: "Items",
                buttonText: "PROCESS",
                showRupee: false,
                onButtonTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DeliveryPlaceOderPage(
                      pickUp: pickup,
                    );
                  }));
                },
              );
            })),
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
                        "assets/pickup.png",
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
                  child: Builder(
                    builder: (context) {
                      return CustomAppBar(
                        leading: "assets/back.svg",
                        drawer: "assets/drawer.svg",
                        title: "Pickup & Drop",
                        onTapLeading: () {
                          Navigator.pop(context);
                        },
                        onTapDrawer: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: (AppUtil.getScreenHeight(context) -
                      AppUtil.getToolbarHeight(context)) /
                  AppUtil.getScreenHeight(context),
              minChildSize: (AppUtil.getScreenHeight(context) -
                      AppUtil.getToolbarHeight(context)) /
                  AppUtil.getScreenHeight(context),
              maxChildSize: 1.0,
              builder: (context, controller) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(32),
                          topLeft: Radius.circular(32))),
                  padding: EdgeInsets.only(
                      left: horizontalPaddingDraggable,
                      right: horizontalPaddingDraggable,
                      top: 20),
                  child: CustomScrollView(
                    controller: controller,
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras scelerisque, nisi in sodales ornare, dolor erat vehicula nibh, et vulputate sapien sapien ut risus. ",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: BlocBuilder<DeliveryOrderBloc, PickUp>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () async {
                                Shop shop = await Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PickShopLocationPage(
                                    shop: state.shop,
                                  );
                                }));

                                _bloc.add(ChooseShop(shop));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                margin: EdgeInsets.only(bottom: 30),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12)),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: BlocBuilder<DeliveryOrderBloc,
                                          PickUp>(
                                        builder: (context, state) {
                                          return TextField(
                                            enabled: false,
                                            controller: TextEditingController(
                                                text: state.shop == null
                                                    ? null
                                                    : state.shop.name),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 15),
                                              border: InputBorder.none,
                                              hintText: "SELECT SHOP",
                                              hintStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black38),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/locationpick.svg",
                                      width: 22,
                                      height: 22,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "ADD ITEMS",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SliverAnimatedList(
                        key: _keySliverAnimatedList,
                        itemBuilder: (context, i, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: CustomTextField(
                              hint: "Add item here",
                              index: i,
                              controller: _controllers[i],
                              suffix: "assets/remove.svg",
                            ),
                          );
                        },
                      ),
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          onTap: () {
                            _controllers.insert(0, TextEditingController());
                            _keySliverAnimatedList.currentState.insertItem(0,
                                duration: Duration(milliseconds: 400));
                            BlocProvider.of<DeliveryOrderBloc>(context)
                                .add(AddTextField());
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12)),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15)),
                              enabled: false,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Text(
                            "ATTACHMENTS",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 60,
                          width: AppUtil.getScreenWidth(context),
                          margin: EdgeInsets.only(bottom: 30),
                          child: BlocBuilder<DeliveryOrderBloc, PickUp>(
                              builder: (context, state) {
                            return AnimatedList(
                              key: _keyAnimatedList,
                              itemBuilder: (context, i, animation) {
                                if (i == state.attachment.length) {
                                  return AddAttachmentButton(
                                    onTap: () {
                                      _chooseImage();
                                    },
                                  );
                                }
                                return FadeTransition(
                                    opacity: animation,
                                    child:
                                        ImageThumbnail(i, state.attachment[i]));
                              },
                              scrollDirection: Axis.horizontal,
                              initialItemCount: 1,
                            );
                          }),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                            margin: EdgeInsets.only(
                                bottom: kBottomNavigationBarHeight),
                            child: PickupInformationWidget()),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _chooseImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: new Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      PickedFile file = await ImagePicker().getImage(
                          source: ImageSource.camera, imageQuality: 20);
                      if (file != null) {
                        _keyAnimatedList.currentState.insertItem(0,
                            duration: Duration(milliseconds: 400));
                        _bloc.add(AddAttachment(File(file.path)));
                      }
                    },
                    splashColor: Colors.black12,
                    child: ListTile(
                      leading: new Icon(
                        Icons.photo_camera,
                      ),
                      title: Text("Camera"),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      PickedFile file = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (file != null) {
                        _keyAnimatedList.currentState.insertItem(0,
                            duration: Duration(milliseconds: 400));
                        _bloc.add(AddAttachment(File(file.path)));
                      }
                    },
                    splashColor: Colors.black12,
                    child: ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                      ),
                      title: Text("Gallery"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final String suffix;
  final double bottom;
  final int index;
  final TextEditingController controller;

  const CustomTextField({
    Key key,
    this.index,
    this.hint,
    this.suffix,
    this.bottom = 20,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: bottom),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (text) {
                if (text != "") {
                  BlocProvider.of<DeliveryOrderBloc>(context)
                      .add(UpdateItem(index, text));
                }
              },
              autofocus: true,
              controller: controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                hintText: hint == null ? "" : hint,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
              ),
            ),
          ),
          suffix != null
              ? GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    suffix,
                    width: 22,
                    height: 22,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class PickupInformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
          child: Text(
            "Upto 8 kg allowed",
            style: TextStyle(fontSize: 13),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
          child: Text(
            "Item's amount will be collected as COD while delivering",
            style: TextStyle(fontSize: 13),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
          child: Text(
            "Starts Rs. 40 for first 2 Km, evert additional Km Rs. 15 added",
            style: TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }
}

class AddAttachmentButton extends StatelessWidget {
  final Function onTap;

  const AddAttachmentButton({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 15),
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.yellow[600],
          dashPattern: [6, 6, 6, 6],
          radius: Radius.circular(8),
          strokeCap: StrokeCap.round,
          child: Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            child: Icon(
              Icons.add,
              size: 33,
              color: Colors.yellow[600],
            ),
          ),
        ),
      ),
    );
  }
}

class ImageThumbnail extends StatelessWidget {
  final int index;
  final File file;

  ImageThumbnail(this.index, this.file);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
