import 'dart:io';

import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/bloc/login/login_bloc.dart';
import 'package:clients/bloc/pickup/placeorder/bloc.dart';
import 'package:clients/model/address.dart';
import 'package:clients/model/location.dart';
import 'package:clients/model/place_order_pickup.dart';
import 'package:clients/page/placed_order_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clients/bloc/address/address_bloc.dart';
import 'package:clients/bloc/address/address_event.dart';
import 'package:clients/bloc/address/address_repository.dart';
import 'package:clients/bloc/address/address_state.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/pickup.dart';
import 'package:clients/page/address_page.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:clients/widget/end_drawer.dart';
import 'package:clients/widget/place_order_bottom_navbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DeliveryPlaceOderPage extends StatefulWidget {
  final PickUp pickUp;
  final List<String> pickUpInfo;
  final Location location;

  const DeliveryPlaceOderPage(
      {Key key, this.pickUp, this.pickUpInfo, this.location})
      : super(key: key);

  @override
  _DeliveryPlaceOderPageState createState() => _DeliveryPlaceOderPageState();
}

class _DeliveryPlaceOderPageState extends State<DeliveryPlaceOderPage>
    with SingleTickerProviderStateMixin {
  AddressBloc _addressBloc;
  PlaceOrderPickupBloc _orderPickupBloc;
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    widget.pickUp.items.removeWhere((item) {
      return item == "" || item == null;
    });

    _addressBloc = AddressBloc(AddressRepository());
    _orderPickupBloc = PlaceOrderPickupBloc();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    _addressBloc.close();
    _orderPickupBloc.close();
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AddressBloc>(
              create: (context) {
                return _addressBloc;
              },
            ),
            BlocProvider<PlaceOrderPickupBloc>(
              create: (context) {
                return _orderPickupBloc
                  ..add(InitPlaceOrder(
                      loginState.user.token,
                      widget.pickUp,
                      loginState.user.defaultAddress,
                      loginState.user.phone,
                      widget.location.locationName));
              },
            ),
          ],
          child: Scaffold(
            endDrawer: EndDrawer(),
            body: BlocBuilder<PlaceOrderPickupBloc, PlaceOrderPickupState>(
              builder: (context, state) {
                if (state is InitialPlaceOrderPickupState) {
                  return Container();
                }
                return Stack(
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
                              top: horizontalPaddingDraggable,
                              bottom: horizontalPaddingDraggable),
                          child: CustomScrollView(
                            controller: controller,
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 25),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          "assets/locationpick.svg",
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Text(
                                                  widget.pickUp.shop.name,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )),
                                            Text(
                                              widget.pickUp.shop.address,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          "assets/additems.svg",
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                child: Text(
                                                  "ADD ITEMS",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                )),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                  widget.pickUp.items.length,
                                                  (index) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 15),
                                                  child: Text(
                                                    widget.pickUp.items[index],
                                                    textAlign: TextAlign.start,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                );
                                              }),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          "assets/attachment.svg",
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 15),
                                            child: Text(
                                              "ATTACHMENTS",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          widget.pickUp.attachment.length != 0
                                              ? Container(
                                                  width: AppUtil.getScreenWidth(
                                                          context) -
                                                      80,
                                                  child: Wrap(
                                                    direction: Axis.horizontal,
                                                    children: List.generate(
                                                        widget.pickUp.attachment
                                                            .length, (index) {
                                                      return ImageThumbnail(
                                                          0,
                                                          widget.pickUp
                                                                  .attachment[
                                                              index]);
                                                    }),
                                                  ),
                                                )
                                              : Container(
                                                  child: Text(
                                                    "No Attachment",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 20,
                                        margin: EdgeInsets.only(right: 20),
                                        child: SvgPicture.asset(
                                          "assets/distance.svg",
                                          height: 20,
                                          width: 20,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(bottom: 15),
                                            child: Text(
                                              "DISTANCE",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          Container(
                                            width: AppUtil.getScreenWidth(
                                                    context) -
                                                80,
                                            child: Text(
                                              state.placeOrderPickup.distance !=
                                                      null
                                                  ? state.placeOrderPickup
                                                          .distance +
                                                      " kilometers"
                                                  : "",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              BlocBuilder<PlaceOrderPickupBloc,
                                  PlaceOrderPickupState>(
                                builder: (context, state) {
                                  if (state is LoadingGetDeliveryCharge ||
                                      state is LoadingPlaceOrder ||
                                      state is SuccessPlaceOrder ||
                                      state is ErrorPlaceOrder) {
                                    return SliverToBoxAdapter(
                                        child: SizedBox());
                                  }

                                  if (loginState.user.defaultAddress == null) {
                                    return SliverToBoxAdapter(
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 20),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.red[700],
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          "No Address Found",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }

                                  return SliverToBoxAdapter(
                                    child: !state.placeOrderPickup.isValid
                                        ? Container(
                                            margin: EdgeInsets.only(bottom: 20),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.red[700],
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text(
                                              state.placeOrderPickup.message,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        : SizedBox(),
                                  );
                                },
                              ),
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: 150 + kBottomNavigationBarHeight),
                                  child: PickupInformationWidget(
                                    infoList: widget.pickUpInfo,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      child: Column(
                        children: <Widget>[
                          PickUpDeliveryInformation(
                            address: state.placeOrderPickup.address,
                            token: loginState.user.token,
                            orderPickupBloc: _orderPickupBloc,
                            addressBloc: _addressBloc,
                            contact: state.placeOrderPickup.contact,
                          ),
                          OrderBottomNavBar(
                            isValid: state.placeOrderPickup.isValid,
                            onButtonTap: state.placeOrderPickup.isValid
                                ? () {
                                    openRazorPayCheckOut(
                                        state.placeOrderPickup);
                                  }
                                : () {},
                            currencyIcon: AppUtil.getCurrencyIcon(
                                state.placeOrderPickup.currencyCode),
                            showCurrency: (state is LoadingGetDeliveryCharge)
                                ? false
                                : true,
                            amount: (state is LoadingGetDeliveryCharge)
                                ? "..."
                                : AppUtil.doubleRemoveZeroTrailing(
                                    state.placeOrderPickup.deliveryAmount),
                            buttonText: "PLACE ORDER",
                            description: (state is LoadingGetDeliveryCharge)
                                ? "Calculating..."
                                : "Total Amount",
                          ),
                        ],
                      ),
                    ),
                    BlocConsumer<PlaceOrderPickupBloc, PlaceOrderPickupState>(
                      listener: (context, state) async {
                        if (state is SuccessPlaceOrder) {
                          if (state.placeOrderPickup.isChangePrimaryContact) {
                            BlocProvider.of<LoginBloc>(context).add(
                                UpdatePrimaryContact(
                                    state.placeOrderPickup.contact));
                            await _showContactConfirmationDialog(
                                state.placeOrderPickup.contact);
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return PlacedOrderSuccessPage(
                              placeOrderId: state.placeOrderPickup.id,
                              token: loginState.user.token,
                              address: widget.location.address,
                              isPickupOrder: true,
                            );
                          }));
                        } else if (state is ErrorPlaceOrder) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: Text(
                                    "Place Order Error",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: Text(state.message),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingPlaceOrder) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5)),
                            child: Center(
                              child: SpinKitCircle(
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  openRazorPayCheckOut(PlaceOrderPickup placeOrderPickup) {
    var options = {
      "key": placeOrderPickup.razorKey,
      //"rzp_test_shynWbWngI8JsA", // change to placeOrder.razorKey
      "amount": (placeOrderPickup.deliveryAmount * 100.0).ceil().toString(),
      "name": "Flyer Eats",
      "description": "Payment for Flyer Eats Order",
      "prefill": {
        "contact": placeOrderPickup.contact,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) {
    _orderPickupBloc.add(PlaceOrderEvent());
  }

  void handlerPaymentError(PaymentFailureResponse response) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              "Error",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              response.message,
              style: TextStyle(color: Colors.black54),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK")),
            ],
          );
        },
        barrierDismissible: true);
  }

  void handlerExternalWallet(ExternalWalletResponse response) {}

  Future<void> _showContactConfirmationDialog(String contact) {
    return showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.all(horizontalPaddingDraggable),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text("NOTIFICATION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text("Your Number",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14, color: Colors.black38)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(contact,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "will be used as login ID for next time and the OTP will be used as password",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFB531),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "GOT IT",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ]));
        });
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
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4)),
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

class ImageThumbnail extends StatelessWidget {
  final int index;
  final File file;

  ImageThumbnail(this.index, this.file);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      margin: EdgeInsets.only(right: 15, bottom: 15),
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

class PickUpDeliveryInformation extends StatefulWidget {
  final Address address;
  final String token;
  final String contact;
  final AddressBloc addressBloc;
  final PlaceOrderPickupBloc orderPickupBloc;

  const PickUpDeliveryInformation(
      {Key key,
      this.address,
      this.token,
      this.addressBloc,
      this.orderPickupBloc,
      this.contact})
      : super(key: key);

  @override
  _PickUpDeliveryInformationState createState() =>
      _PickUpDeliveryInformationState();
}

class _PickUpDeliveryInformationState extends State<PickUpDeliveryInformation> {
  int _countrySelected = 0;
  String _contactPredicate = "+91";
  String _number;
  bool _isChangePrimaryNumber = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.address == null
        ? Container(
            height: 90,
            width: AppUtil.getScreenWidth(context),
            padding: EdgeInsets.symmetric(
                vertical: horizontalPaddingDraggable - 5,
                horizontal: horizontalPaddingDraggable),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.orange[100],
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(0, -1)),
            ]),
            child: GestureDetector(
              onTap: () async {
                Address address = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return AddressPage(
                    forcedDefault: true,
                  );
                }));

                if (address != null) {
                  BlocProvider.of<LoginBloc>(context)
                      .add(UpdateDefaultAddress(address));
                  widget.orderPickupBloc.add(ChangeAddress(address));
                }
                //widget.addressBloc.add(InitDefaultAddress());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Delivery to:"),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        "ADD NEW ADDRESS",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container(
            height: 145,
            width: AppUtil.getScreenWidth(context),
            padding: EdgeInsets.symmetric(
                vertical: horizontalPaddingDraggable - 5,
                horizontal: horizontalPaddingDraggable),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.orange[100],
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(0, -1)),
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Delivery To"),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          widget.address.title,
                          maxLines: 1,
                          style: TextStyle(backgroundColor: Colors.yellow[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showChangeAddressSheet();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: Text(
                          "Change",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Text(
                        widget.address.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Divider(
                    color: Colors.black12,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: "Contact Number: ",
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: widget.contact,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black))
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showChangeContactSheet();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        child: Text(
                          "Change",
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  void _showChangeAddressSheet() {
    BlocProvider.of<AddressBloc>(context).add(OpenListAddress(widget.token));

    showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        context: context,
        builder: (context) {
          return BlocBuilder<AddressBloc, AddressState>(
            bloc: widget.addressBloc,
            builder: (context, state) {
              if (state is ListAddressLoaded) {
                List<Address> list = state.list;
                List<Widget> address = [];
                for (int i = 0; i < list.length; i++) {
                  address.add(AddressItemWidget(
                    address: list[i],
                    onTap: () {
                      widget.orderPickupBloc.add(ChangeAddress(list[i]));
                      BlocProvider.of<LoginBloc>(context)
                          .add(UpdateDefaultAddress(list[i]));
                      Navigator.pop(context);
                    },
                  ));
                }

                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              bottom: kBottomNavigationBarHeight,
                              top: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 52),
                              ),
                              Container(
                                child: Column(
                                  children: address,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                            width: AppUtil.getScreenWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(32),
                                    topRight: Radius.circular(32)),
                                color: Colors.white),
                            padding:
                                EdgeInsets.only(top: 20, left: 20, bottom: 20),
                            child: Text(
                              "SELECT ADDRESS",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                      ),
                      Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AddressPage();
                              }));
                            },
                            child: Container(
                              width: AppUtil.getScreenWidth(context),
                              height: kBottomNavigationBarHeight,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Text(
                                    "ADD NEW ADDRESS",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Positioned(
                          top: 5,
                          right: 0,
                          child: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                Navigator.pop(context);
                              }))
                    ],
                  ),
                );
              } else if (state is LoadingListAddress) {
                return Container(
                  child: Center(
                      child: SpinKitCircle(
                    color: Colors.black38,
                    size: 30,
                  )),
                );
              } else if (state is ErrorLoadingListAddress) {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("Fail load addresses")));
              }
              return Container();
            },
          );
        });
  }

  void _showChangeContactSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: AppUtil.getScreenWidth(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32)),
                            color: Colors.white),
                        padding: EdgeInsets.only(top: 20, left: 20, bottom: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "ENTER NUMBER",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontalPaddingDraggable),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12, width: 2)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<int>(
                              underline: Container(),
                              isExpanded: false,
                              isDense: true,
                              iconSize: 0,
                              value: _countrySelected,
                              items: [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Container(
                                    width: 80,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            child: SvgPicture.asset(
                                                "assets/india_flag.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "+91",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Container(
                                    width: 80,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 20,
                                            child: SvgPicture.asset(
                                                "assets/singapore_flag.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "+65",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (i) {
                                state(() {
                                  _countrySelected = i;
                                  _contactPredicate = i == 0 ? "+91" : "+65";
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color: Colors.black12, width: 2))),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                onChanged: (value) {
                                  state(() {
                                    _number = value;
                                  });
                                },
                                autofocus: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                  hintText: "Enter phone number",
                                  hintStyle: TextStyle(
                                      fontSize: 16, color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontalPaddingDraggable, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: _isChangePrimaryNumber,
                            onChanged: (value) {
                              state(() {
                                _isChangePrimaryNumber = value;
                              });
                            },
                            visualDensity:
                                VisualDensity(vertical: 0, horizontal: 0),
                          ),
                          Expanded(
                              child: Text(
                                  "Do you want to make this number as your primary and login number?"))
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _number != "" && _number != null
                          ? () {
                              widget.orderPickupBloc.add(ChangeContact(
                                  _contactPredicate + _number,
                                  _isChangePrimaryNumber));
                              Navigator.pop(context);
                            }
                          : () {},
                      child: Container(
                        margin: EdgeInsets.only(
                            left: horizontalPaddingDraggable,
                            right: horizontalPaddingDraggable,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 32),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFB531),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "SELECT",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity:
                                  _number != "" && _number != null ? 0.0 : 0.5,
                              child: Container(
                                height: 50,
                                color: Colors.white,
                              ),
                              duration: Duration(milliseconds: 300),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

class AddressItemWidget extends StatelessWidget {
  final Address address;
  final Function onTap;

  const AddressItemWidget({Key key, this.address, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type;
    String icon;
    switch (address.type) {
      case AddressType.home:
        type = "HOME";
        icon = "assets/home address.svg";
        break;
      case AddressType.office:
        type = "OFFICE";
        icon = "assets/office address.svg";
        break;
      case AddressType.other:
        type = "OTHER";
        icon = "assets/others address.svg";
        break;
      default:
        break;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(
                      icon,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            type,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            address.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          address.address,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: Colors.black45),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black12,
            )
          ],
        ),
      ),
    );
  }
}
