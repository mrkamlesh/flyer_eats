import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flyereats/bloc/shop/bloc.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/shop.dart';

class PickShopLocationPage extends StatefulWidget {
  final Shop shop;

  const PickShopLocationPage({Key key, this.shop}) : super(key: key);

  @override
  _PickShopLocationPageState createState() => _PickShopLocationPageState();
}

class _PickShopLocationPageState extends State<PickShopLocationPage> {
  ChooseShopBloc _bloc = ChooseShopBloc();
  TextEditingController nameController;
  TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    _bloc.add(PageOpen(widget.shop));
    nameController = TextEditingController(
        text: widget.shop != null
            ? widget.shop.name != null ? widget.shop.name : ""
            : "");
    addressController = TextEditingController(
        text: widget.shop != null
            ? widget.shop.address != null ? widget.shop.address : ""
            : "");
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChooseShopBloc>(
      create: (context) {
        return _bloc;
      },
      child: Scaffold(
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
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black45),
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset(
                      "assets/back.svg",
                      color: Colors.white,
                    )),
              ),
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
                child: BlocBuilder<ChooseShopBloc, Shop>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CustomTextField(
                          controller: nameController,
                          hint: "ENTER SHOP",
                          onChange: (text) {
                            _bloc.add(EntryShopName(text));
                          },
                        ),
                        CustomTextField(
                          controller: addressController,
                          hint: "Enter Shop Number, Building Name",
                          onChange: (text) {
                            _bloc.add(EntryAddress(text));
                          },
                        ),
                        CustomTextField(lines: 3, hint: "Address"),
                        BlocBuilder<ChooseShopBloc, Shop>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: state.isValid()
                                  ? () {
                                      Navigator.pop(context, state);
                                    }
                                  : () {},
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
                                      "Done",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    opacity: state.isValid() ? 0.0 : 0.5,
                                    child: Container(
                                      height: 50,
                                      color: Colors.white,
                                    ),
                                    duration: Duration(milliseconds: 300),
                                  )
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final int lines;
  final Function(String) onChange;

  const CustomTextField(
      {Key key, this.hint, this.controller, this.lines, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: TextField(
        controller: controller,
        maxLines: lines,
        onChanged: (text) {
          onChange(text);
        },
        decoration: InputDecoration(
          hintText: hint != null ? hint : "",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
