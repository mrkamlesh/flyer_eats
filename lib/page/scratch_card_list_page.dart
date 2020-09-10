import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clients/bloc/login/bloc.dart';
import 'package:clients/bloc/scratchcardlist/scratch_card_list_bloc.dart';
import 'package:clients/bloc/scratchcardlist/scratch_card_list_event.dart';
import 'package:clients/bloc/scratchcardlist/scratch_card_list_state.dart';
import 'package:clients/classes/app_util.dart';
import 'package:clients/classes/style.dart';
import 'package:clients/model/scratch_card.dart';
import 'package:clients/widget/app_bar.dart';
import 'package:scratcher/scratcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScratchCardPage extends StatefulWidget {
  @override
  _ScratchCardPageState createState() => _ScratchCardPageState();
}

class _ScratchCardPageState extends State<ScratchCardPage> {
  ScratchCardListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ScratchCardListBloc();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, loginState) {
        return BlocProvider<ScratchCardListBloc>(
          create: (context) {
            return _bloc..add(GetScratchCardList(loginState.user.token));
          },
          child: Scaffold(
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
                            "assets/allrestaurant.png",
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
                      child: CustomAppBar(
                        leading: "assets/back.svg",
                        title: "Scratch Card",
                        onTapLeading: () {
                          Navigator.pop(context);
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
                      padding: EdgeInsets.only(top: 20),
                      child: BlocConsumer<ScratchCardListBloc,
                          ScratchCardListState>(
                        listener: (context, state) {
                          if (state is ErrorScratch) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: Text(
                                      "Error",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      state.message,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text("OK")),
                                    ],
                                  );
                                },
                                barrierDismissible: false);
                          }
                        },
                        builder: (context, state) {
                          if (state is LoadingList) {
                            return Container(
                              child: Center(
                                child: SpinKitCircle(
                                  color: Colors.black38,
                                  size: 30,
                                ),
                              ),
                            );
                          } else if (state is ErrorList) {
                            return Container(
                              child: Center(
                                child: Text(state.message),
                              ),
                            );
                          }

                          return CustomScrollView(
                            slivers: <Widget>[
                              SliverToBoxAdapter(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: 15,
                                      left: horizontalPaddingDraggable,
                                      right: horizontalPaddingDraggable),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Text("Total Scratch Card")),
                                      SvgPicture.asset(
                                        AppUtil.getCurrencyIcon(
                                            state.currencyCode),
                                        color: primary3,
                                        height: 20,
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        AppUtil.doubleRemoveZeroTrailing(
                                            state.scratchAmountTotal),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 36,
                                            color: primary3,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: EdgeInsets.only(
                                    left: horizontalPaddingDraggable,
                                    right: horizontalPaddingDraggable),
                                sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20,
                                            childAspectRatio: 1.2,
                                            crossAxisCount: 2),
                                    delegate: SliverChildBuilderDelegate(
                                        (context, i) {
                                      return ScratchCardWidget(
                                        scratchCard: state.scratchList[i],
                                        currencyCode: state.currencyCode,
                                        onTap: () {
                                          _showScratchCard(
                                              loginState.user.token,
                                              state.scratchList[i],
                                              i,
                                              state.currencyCode);
                                        },
                                      );
                                    }, childCount: state.scratchList.length)),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 30,
                                ),
                              ),
                            ],
                          );
                        },
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

  void _showScratchCard(
      String token, ScratchCard scratchCard, int pos, String currencyCode) {
    double opacity = 0.0;
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newState) {
              return SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(32)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.clear,
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 9,
                            child: Text(
                              "Scratch Card",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Divider(
                          height: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child:
                            Center(child: Text("You Have Won A Scratch Card!")),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Scratcher(
                          accuracy: ScratchAccuracy.medium,
                          brushSize: 50,
                          threshold: 25,
                          //color: appLogoBackground,
                          onThreshold: () {
                            newState(() {
                              opacity = 1.0;
                            });
                            _bloc.add(
                                DoScratchCard(token, scratchCard.cardId, pos));
                            Future.delayed(Duration(seconds: 2))
                                .then((value) => Navigator.pop(context));
                          },
                          image: Image.asset(
                            "assets/scratch card.png",
                            fit: BoxFit.none,
                          ),
                          child: Container(
                            height: 0.7 * AppUtil.getScreenWidth(context),
                            width: AppUtil.getScreenWidth(context),
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: opacity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  color: primary2,
                                  strokeWidth: 2,
                                  dashPattern: [8, 8, 8, 8],
                                  radius: Radius.circular(8),
                                  strokeCap: StrokeCap.round,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/scratch_won_icon.svg",
                                          height: 0.16 *
                                              0.7 *
                                              AppUtil.getScreenWidth(context),
                                          width: 0.16 *
                                              0.7 *
                                              AppUtil.getScreenWidth(context),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            "You Won",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppUtil.getCurrencyIcon(
                                                  currencyCode),
                                              width: 30,
                                              height: 30,
                                              color: primary3,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppUtil.doubleRemoveZeroTrailing(
                                                  scratchCard.amount),
                                              style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                  color: primary3),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: AnimatedOpacity(
                              opacity: 1.0 - opacity,
                              duration: Duration(milliseconds: 300),
                              child: Text(
                                  "Expired On: " + scratchCard.dateExpiration)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}

class ScratchCardWidget extends StatelessWidget {
  final ScratchCard scratchCard;
  final String currencyCode;
  final Function onTap;

  const ScratchCardWidget(
      {Key key, this.scratchCard, this.currencyCode, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scratchCard.isScratched
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: primary2,
                  strokeWidth: 2,
                  dashPattern: [8, 8, 8, 8],
                  radius: Radius.circular(8),
                  strokeCap: StrokeCap.round,
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/scratch_won_icon.svg",
                          height:
                              0.16 * (AppUtil.getScreenWidth(context) - 60) / 2,
                          width:
                              0.16 * (AppUtil.getScreenWidth(context) - 60) / 2,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "You Won",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppUtil.getCurrencyIcon(currencyCode),
                              width: 12,
                              height: 12,
                              color: primary3,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              AppUtil.doubleRemoveZeroTrailing(
                                  scratchCard.amount),
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: primary3),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Center(
                    child: Text(
                  "Scratched On: " + scratchCard.dateScratched,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(fontSize: 11),
                )),
              ),
            ],
          )
        : InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: Image.asset(
                        "assets/scratch card.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Center(
                      child: Text(
                    "Expired On: " + scratchCard.dateExpiration,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontSize: 11),
                  )),
                ),
              ],
            ),
          );
  }
}
