import 'package:clients/classes/style.dart';
import 'package:clients/model/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentMethodListWidget extends StatefulWidget {
  final List<PaymentMethod> paymentMethods;
  final Function(int) onTap;

  const PaymentMethodListWidget({Key key, this.paymentMethods, this.onTap})
      : super(key: key);

  @override
  _PaymentMethodListWidgetState createState() =>
      _PaymentMethodListWidgetState();
}

class _PaymentMethodListWidgetState extends State<PaymentMethodListWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  int _selectedPaymentMethod = -1;

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
    List<PaymentMethodItem> list = List();
    for (int i = 0; i < widget.paymentMethods.length; i++) {
      list.add(PaymentMethodItem(
        method: widget.paymentMethods[i],
        index: i,
        selectedIndex: _selectedPaymentMethod,
        scale: _scaleAnimation,
        onTap: () {
          setState(() {
            _selectedPaymentMethod = i;
            _animationController.forward().orCancel.whenComplete(() {
              _animationController.reverse().orCancel.whenComplete(() {
                widget.onTap(i);
              });
            });
          });
        },
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final PaymentMethod method;
  final int index;
  final int selectedIndex;
  final Animation<double> scale;
  final Function onTap;

  const PaymentMethodItem(
      {Key key,
      this.method,
      this.index,
      this.selectedIndex,
      this.scale,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: horizontalPaddingDraggable),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  method.getIcon(),
                  height: 36,
                  width: 36,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text(
                    method.label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: 10, horizontal: horizontalPaddingDraggable),
          child: Divider(
            height: 1.0,
            color: Colors.black38,
          ),
        )
      ],
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
