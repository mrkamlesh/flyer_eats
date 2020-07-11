import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flyereats/bloc/login/bloc.dart';
import 'package:flyereats/bloc/scratchcardlist/scratch_card_list_bloc.dart';
import 'package:flyereats/bloc/scratchcardlist/scratch_card_list_event.dart';
import 'package:flyereats/bloc/scratchcardlist/scratch_card_list_state.dart';
import 'package:flyereats/classes/app_util.dart';
import 'package:flyereats/classes/style.dart';
import 'package:flyereats/model/scratch_card.dart';
import 'package:flyereats/widget/app_bar.dart';
import 'package:scratcher/scratcher.dart';

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
                      child: BlocConsumer<ScratchCardListBloc, ScratchCardListState>(
                        listener: (context, state) {
                          if (state is ErrorScratch) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    title: Text(
                                      "Error",
                                      style: TextStyle(fontWeight: FontWeight.bold),
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
                                      bottom: 15, left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("Total Scratch Card"),
                                      Text(
                                        state.currency +
                                            " " +
                                            AppUtil.doubleRemoveZeroTrailing(state.scratchAmountTotal),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 36, color: primary3, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SliverPadding(
                                padding: EdgeInsets.only(
                                    left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                                sliver: SliverGrid(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20,
                                        childAspectRatio: 1.2,
                                        crossAxisCount: 2),
                                    delegate: SliverChildBuilderDelegate((context, i) {
                                      return ScratchCardWidget(
                                        scratchCard: state.scratchList[i],
                                        currency: state.currency,
                                        onTap: () {
                                          _showScratchCard(loginState.user.token, state.scratchList[i], i);
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

  void _showScratchCard(String token, ScratchCard scratchCard, int pos) {
    double opacity = 0.0;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newState) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
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
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        child: Center(child: Text("You Have Won A Scratch Card!")),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Scratcher(
                          accuracy: ScratchAccuracy.medium,
                          brushSize: 50,
                          threshold: 25,
                          color: Colors.black,
                          onThreshold: () {
                            newState(() {
                              opacity = 1.0;
                            });
                            _bloc.add(DoScratchCard(token, scratchCard.cardId, pos));
                          },
                          image: Image.asset(
                            "assets/flyereatslogo.png",
                            fit: BoxFit.none,
                            width: AppUtil.getScreenWidth(context) - 100,
                            height: 0.7 * AppUtil.getScreenWidth(context) - 100,
                          ),
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: opacity,
                            child: Container(
                              height: 0.7 * AppUtil.getScreenWidth(context),
                              width: AppUtil.getScreenWidth(context),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Center(
                                child: Text(
                                  "\u20b9 " + AppUtil.doubleRemoveZeroTrailing(scratchCard.amount),
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50, color: primary3),
                                ),
                              ),
                            ),
                          ),
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
  final String currency;
  final Function onTap;

  const ScratchCardWidget({Key key, this.scratchCard, this.currency, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scratchCard.isScratched
        ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, spreadRadius: 2)]),
            child: Center(
              child: Text(
                currency + " " + AppUtil.doubleRemoveZeroTrailing(scratchCard.amount),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primary3),
              ),
            ),
          )
        : InkWell(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black),
                padding: EdgeInsets.only(left: horizontalPaddingDraggable, right: horizontalPaddingDraggable),
                child: Image.asset(
                  "assets/flyereatslogo.png",
                ),
              ),
            ),
          );
  }
}
