import 'dart:io';

import 'package:clients/bloc/pickup/process/delivery_order_bloc.dart';
import 'package:clients/bloc/pickup/process/delivery_order_event.dart';
import 'package:clients/bloc/pickup/process/delivery_order_state.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/model/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clients/model/shop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/page/delivery_pickup_location.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/end_drawer.dart';
import 'package:clients/widget/place_order_bottom_navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clients/page/delivery_place_order_page.dart';

class DeliveryProcessOrderPage extends StatefulWidget {
  final Location location;

  const DeliveryProcessOrderPage({Key key, this.location}) : super(key: key);

  @override
  _DeliveryProcessOrderPageState createState() => _DeliveryProcessOrderPageState();
}

class _DeliveryProcessOrderPageState extends State<DeliveryProcessOrderPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _navBarAnimation;

  List<TextEditingController> _controllers = List();
  List<FocusNode> _focusNodes = List();

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
    _navBarAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, kBottomNavigationBarHeight))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<DeliveryOrderBloc>(
          create: (context) {
            return _bloc..add(GetInfo(loginState.user.token, widget.location.address));
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
                child: BlocBuilder<DeliveryOrderBloc, DeliveryOrderState>(builder: (context, state) {
                  int length = 0;
                  for (int i = 0; i < state.pickUp.items.length; i++) {
                    if ((state.pickUp.items[i] != null) & (state.pickUp.items[i] != "")) {
                      length++;
                    }
                  }
                  return OrderBottomNavBar(
                    isValid: state.pickUp.isValid(),
                    amount: length,
                    description: "Items",
                    buttonText: "VIEW CHART",
                    showRupee: false,
                    onButtonTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return DeliveryPlaceOderPage(
                          pickUp: state.pickUp,
                          pickUpInfo: _getPickUpInfoList(state.pickUpInfo),
                          location: widget.location,
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
                  initialChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  minChildSize: (AppUtil.getScreenHeight(context) - AppUtil.getToolbarHeight(context)) /
                      AppUtil.getScreenHeight(context),
                  maxChildSize: 1.0,
                  builder: (context, controller) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32))),
                      padding: EdgeInsets.only(top: 20),
                      child: CustomScrollView(
                        controller: controller,
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 30,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                              ),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras scelerisque, nisi in sodales ornare, dolor erat vehicula nibh, et vulputate sapien sapien ut risus. ",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: BlocBuilder<DeliveryOrderBloc, DeliveryOrderState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () async {
                                    Shop shop = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                      return PickShopLocationPage(
                                        shop: state.pickUp.shop,
                                      );
                                    }));

                                    _bloc.add(ChooseShop(shop));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    margin: EdgeInsets.only(
                                      bottom: 30,
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black12)),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: BlocBuilder<DeliveryOrderBloc, DeliveryOrderState>(
                                            builder: (context, state) {
                                              return TextField(
                                                enabled: false,
                                                controller: TextEditingController(
                                                    text: state.pickUp.shop == null ? null : state.pickUp.shop.name),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                                                  border: InputBorder.none,
                                                  hintText: "SELECT SHOP",
                                                  hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
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
                              margin: EdgeInsets.only(
                                bottom: 10,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                              ),
                              child: Text(
                                "ADD ITEMS",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          BlocBuilder<DeliveryOrderBloc, DeliveryOrderState>(
                            builder: (context, state) {
                              return SliverAnimatedList(
                                key: _keySliverAnimatedList,
                                itemBuilder: (context, i, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SizeTransition(
                                      sizeFactor: CurvedAnimation(
                                          parent: animation.drive(Tween<double>(begin: 0.0, end: 1.0)),
                                          curve: Interval(0.0, 1.0)),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                                        child: CustomTextField(
                                          controller: _controllers[i],
                                          focusNode: _focusNodes[i],
                                          onRemove: () {
                                            _bloc.add(RemoveItem(i));
                                            TextEditingController removedController = _controllers.removeAt(i);
                                            FocusNode removedFocusNode = _focusNodes.removeAt(i);
                                            _keySliverAnimatedList.currentState.removeItem(
                                              i,
                                              (BuildContext context, Animation<double> animation) {
                                                return FadeTransition(
                                                  opacity:
                                                      CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
                                                  child: SizeTransition(
                                                    sizeFactor:
                                                        CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
                                                    axisAlignment: 0.0,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
                                                      child: CustomTextField(
                                                        focusNode: removedFocusNode,
                                                        controller: removedController,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              duration: Duration(milliseconds: 600),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          BlocBuilder<DeliveryOrderBloc, DeliveryOrderState>(
                            builder: (context, pickup) {
                              return SliverToBoxAdapter(
                                child: GestureDetector(
                                  onTap: () {
                                    _keySliverAnimatedList.currentState
                                        .insertItem(pickup.pickUp.items.length, duration: Duration(milliseconds: 400));
                                    TextEditingController newController = TextEditingController();
                                    newController.addListener(() {
                                      _bloc.add(UpdateItem(_controllers.indexOf(newController), newController.text));
                                    });
                                    _controllers.insert(pickup.pickUp.items.length, newController);
                                    FocusNode focusNode = FocusNode();
                                    focusNode.requestFocus();
                                    _focusNodes.insert(pickup.pickUp.items.length, focusNode);
                                    _bloc.add(AddItem(pickup.pickUp.items.length));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      bottom: 30,
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.black12)),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 15)),
                                      enabled: false,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(
                                bottom: 15,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                              ),
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
                              margin: EdgeInsets.only(
                                bottom: 30,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                              ),
                              child: BlocBuilder<DeliveryOrderBloc, DeliveryOrderState>(builder: (context, state) {
                                return AnimatedList(
                                  key: _keyAnimatedList,
                                  itemBuilder: (context, i, animation) {
                                    if (i == state.pickUp.attachment.length) {
                                      return AddAttachmentButton(
                                        onTap: () {
                                          _chooseImage();
                                        },
                                      );
                                    }
                                    return FadeTransition(
                                        opacity: animation, child: ImageThumbnail(i, state.pickUp.attachment[i]));
                                  },
                                  scrollDirection: Axis.horizontal,
                                  initialItemCount: 1,
                                );
                              }),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: horizontalPaddingDraggable, horizontal: horizontalPaddingDraggable),
                              margin: EdgeInsets.only(
                                bottom: 20,
                                left: horizontalPaddingDraggable,
                                right: horizontalPaddingDraggable,
                              ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "DELIVERY INSTRUCTION",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    color: Colors.black12,
                                  ),
                                  TextField(
                                    onChanged: (value) {
                                      _bloc.add(UpdateDeliveryInstruction(value));
                                    },
                                    maxLines: 2,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                        hintText: "Enter your instruction here",
                                        hintStyle: TextStyle(fontSize: 12),
                                        border: InputBorder.none),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: BlocBuilder<DeliveryOrderBloc, DeliveryOrderState>(
                              builder: (context, state) {
                                if (state is LoadingInfo) {
                                  return Container(
                                      margin: EdgeInsets.only(
                                        bottom: kBottomNavigationBarHeight + 10,
                                        left: horizontalPaddingDraggable,
                                        right: horizontalPaddingDraggable,
                                      ),
                                      child: Center(child: CircularProgressIndicator()));
                                }

                                return Container(
                                    margin: EdgeInsets.only(
                                      bottom: kBottomNavigationBarHeight + 10,
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable,
                                    ),
                                    child: PickupInformationWidget(
                                      infoList: _getPickUpInfoList(state.pickUpInfo),
                                    ));
                              },
                            ),
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
      },
    );
  }

  List<String> _getPickUpInfoList(String pickUpInfo) {
    if (pickUpInfo == null || pickUpInfo == "") {
      return [];
    } else {
      return pickUpInfo.split(". ");
    }
  }

  void _chooseImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            child: new Container(
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
              child: new Wrap(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      PickedFile file = await ImagePicker().getImage(source: ImageSource.camera, imageQuality: 20);
                      if (file != null) {
                        _keyAnimatedList.currentState.insertItem(0, duration: Duration(milliseconds: 400));
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
                      PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
                      if (file != null) {
                        _keyAnimatedList.currentState.insertItem(0, duration: Duration(milliseconds: 400));
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
  final TextEditingController controller;
  final Function onRemove;
  final FocusNode focusNode;

  const CustomTextField({
    Key key,
    this.controller,
    this.onRemove,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 15, top: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(color: focusNode.hasFocus ? primary2 : Colors.black12, width: focusNode.hasFocus ? 1.5 : 1.0),
          boxShadow: focusNode.hasFocus ? [BoxShadow(color: primary2, blurRadius: 5, spreadRadius: 1)] : []),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              //autofocus: true,
              decoration: InputDecoration(
                hintText: "Add item here",
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black38),
              ),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: SvgPicture.asset(
              "assets/remove.svg",
              width: 22,
              height: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class PickupInformationWidget extends StatelessWidget {
  final List<String> infoList;

  const PickupInformationWidget({Key key, this.infoList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return infoList != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: infoList
                .map((e) => Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        e,
                        style: TextStyle(fontSize: 13),
                      ),
                    ))
                .toList(),
          )
        : SizedBox();
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.black12)),
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
