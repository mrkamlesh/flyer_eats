import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  List<bool> _selections = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.black12,
                  child: Text("This is a map"),
                ),
              ),
              Container(
                width: AppUtil.getScreenWidth(context),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.grey, blurRadius: 5, spreadRadius: 0)
                ]),
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPaddingDraggable,
                    vertical: distanceBetweenSection),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CustomTextField(
                      hint: "ENTER SHOP",
                    ),
                    CustomTextField(lines: 3, hint: "Address"),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ToggleButton(
                            isSelected: _selections[0],
                            title: "HOME",
                            onTap: (){
                              _toggle(0);
                            },
                          ),
                          ToggleButton(
                            isSelected: _selections[1],
                            title: "OFFICE",
                              onTap: (){
                                _toggle(1);
                              }
                          ),
                          ToggleButton(
                            isSelected: _selections[2],
                            title: "OTHER",
                              onTap: (){
                                _toggle(2);
                              }
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
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
                            opacity: 0.0,
                            child: Container(
                              height: 50,
                              color: Colors.white,
                            ),
                            duration: Duration(milliseconds: 300),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
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
        ],
      ),
    );
  }

  void _toggle(int index) {
    setState(() {
      for (int i = 0; i < _selections.length; i++){
        if (i == index){
          _selections[i] = true;
        } else {
          _selections [i] = false;
        }
      }
    });
  }
}

class ToggleButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function onTap;

  const ToggleButton({Key key, this.isSelected, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 35,
        width: (AppUtil.getScreenWidth(context) - 80) / 3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: isSelected ? primary1 : Colors.white,
            border: Border.all(
              color: Colors.black12,
            )),
        duration: Duration(milliseconds: 200),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.home),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
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
      margin: EdgeInsets.only(bottom: 20),
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
